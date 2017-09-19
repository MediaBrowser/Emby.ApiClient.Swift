//
//  ConnectionManager.swift
//  Emby.ApiClient
//


import Foundation

import Alamofire

public class ConnectionManager: ConnectionManagerProtocol {
    
    let clientCapabilities: ClientCapabilities
    var apiClients = [String: ApiClient]()
    let credentialProvider: CredentialProviderProtocol
    let applicationName: String
    let applicationVersion: String
    let device: DeviceProtocol
    let serverDiscovery: ServerDiscoveryProtocol
    let connectService: ConnectService
    let networkConnection: INetworkConnection
    let httpClient: IAsyncHttpClient
    var connectUser: ConnectUser?
    
    // TODO: Add ApiEventListener
    // let apiEventListener: ApiEventListener
    
    
    
    // MARK: - Init

    public init(credentialProvider: CredentialProviderProtocol,
        networkConnection: INetworkConnection,
        serverDiscovery: ServerDiscoveryProtocol,
        httpClient: IAsyncHttpClient,
        applicationName: String,
        applicationVersion: String,
        device: DeviceProtocol,
        clientCapabilities: ClientCapabilities)
    {
        
        self.credentialProvider = credentialProvider
        self.networkConnection = networkConnection
        self.serverDiscovery = serverDiscovery
        self.httpClient = httpClient
        self.applicationName = applicationName
        self.applicationVersion = applicationVersion
        self.device = device
        self.clientCapabilities = clientCapabilities
        
        self.connectService = ConnectService(jsonSerializer: JsonSerializer(), logger: Logger(), httpClient: httpClient, appName: applicationName, appVersion: applicationVersion)
        
        // device.getResumeFromSleepObservable().addObserver(new DeviceResumeFromSleepObservable(this))
    }
    
    
    // MARK: - Finding Servers
    
    public func getAvailableServers(onSuccess: @escaping ([ServerInfo]) -> Void, onError: @escaping (Error?) -> Void) {
        //TODO
        
        var serverDiscoveryFinished = false
        var connectedServersFinished = false
        
        var serverDiscoveryFailed = false
        var connectedServersFailed = false
        
        let credentials = credentialProvider.getCredentials()
        
        print("\(credentials.servers.count) servers in saved credentials")
        
        func appendServerDiscoveryInfo(serverDiscoveryInfo: [ServerDiscoveryInfo]) {
            
            for serverDiscoveryInfoEach in serverDiscoveryInfo {
                
                let serverInfo = ServerInfo()
                
                serverInfo.localAddress = serverDiscoveryInfoEach.address
                serverInfo.id = serverDiscoveryInfoEach.id
                serverInfo.name = serverDiscoveryInfoEach.name
                
                credentials.addOrUpdateServer(server: serverInfo)
            }
        }
        
        func appendConnectUserServer(connectUserServer: [ConnectUserServer]) {
            
            for connectUserServerEach in connectUserServer {
                
                let serverInfo = ServerInfo()
                serverInfo.localAddress = connectUserServerEach.localAddress
                serverInfo.id = connectUserServerEach.id
                serverInfo.name = connectUserServerEach.name
                serverInfo.accessToken = connectUserServerEach.accessKey
                
                credentials.addOrUpdateServer(server: serverInfo)
            }
        }
        
        serverDiscovery.findServers(timeoutMs: 1000,
            
            onSuccess: { (serverDiscoveryInfo: [ServerDiscoveryInfo]) -> Void in
                
                print("serverDiscovery.findServers finished with \(serverDiscoveryInfo.count) servers)")
                
                appendServerDiscoveryInfo(serverDiscoveryInfo: serverDiscoveryInfo)
                
                serverDiscoveryFinished = true
                
                if connectedServersFinished {
                    
                    // cannot return error if we have some results from different scan method so return error only if both methods failed
                    
                    if connectedServersFailed {
                        
                        onError(nil)
                        
                    } else {
                        
                        onSuccess(credentials.servers)
                    }
                }
                
            }, onError: { (error) -> Void in
                
                print("serverDiscovery.findServers failed with \(error))")
                
                serverDiscoveryFinished = true
                serverDiscoveryFailed = true
                
                if connectedServersFinished {
                    
                    // cannot return error if we have some results from different scan method so return error only if both methods failed
                    
                    if connectedServersFailed {
                        
                        onError(nil)
                        
                    } else {
                        
                        onSuccess(credentials.servers)
                    }
                }
                
        } )
        
        if !credentials.connectAccessToken.isEmpty {
            
            ensureConnectUser(credentials: credentials, onSuccess: { () -> Void in
                
                connectedServersFinished = true
                
                do {
                    try self.connectService.GetServers(userId: credentials.connectUserId, connectAccessToken: credentials.connectAccessToken, success: { (results) -> Void in
                        
                        appendConnectUserServer(connectUserServer: results)
                        
                        connectedServersFinished = true
                        if serverDiscoveryFinished {
                            onSuccess(credentials.servers)
                        }
                        
                    }, failure: { (EmbyError) -> Void in
                        
                        connectedServersFinished = true
                        if serverDiscoveryFinished {
                            onSuccess(credentials.servers)
                        }
                    })
                } catch {
                    print("Failed to ConnectService.GetServers() \(error)")
                    
                    // cannot return error if we have some results from different scan method so return error only if both methods failed
                    
                    connectedServersFinished = true
                    connectedServersFailed = true
                    
                    if serverDiscoveryFailed {
                        
                        onError(error)
                        
                    } else {
                        
                        onSuccess(credentials.servers)
                    }
                }
                
                }, onError: { (error) -> Void in
                    connectedServersFinished = true
                    connectedServersFailed = true
            })
            
        } else {
            connectedServersFinished = true
        }
    }
    
    
    // MARK: - Connecting To Servers
    
    public func connect(onSuccess: @escaping (ConnectionResult) -> Void, onError: @escaping (Error) -> Void) {
        getAvailableServers(onSuccess: { (servers) -> Void in
            
            self.connect(servers: servers, onSuccess: { (connectionResult) -> Void in
                onSuccess(connectionResult)
            }, onError: { (error) -> Void in
                onError(error)
            })
            
        }, onError: { (error) -> Void in
            onError(error!)
        })
    }
    
    public func connect(server: ServerInfo, onSuccess: @escaping (ConnectionResult) -> Void, onError: @escaping (Error) -> Void) {
        self.connect(server: server, options: ConnectionOptions(), onSuccess: onSuccess, onError: onError)
    }
    
    public func connect(server: ServerInfo, options: ConnectionOptions, onSuccess: @escaping (ConnectionResult) -> Void, onError: @escaping (Error) -> Void) {
        
        var tests = [ConnectionMode.Manual, ConnectionMode.Local, ConnectionMode.Remote]
        
        if let lastConnectionMode = server.lastConnectionMode {
            tests.remove(at: tests.index(of: lastConnectionMode)!)
            tests.insert(lastConnectionMode, at: 0)
        }
        
        let localNetworkAvailable = networkConnection.getNetworkStatus().anyLocalNetworkAvailable
        let sendWakeOnLan = server.wakeOnLanInfos.count > 0 && localNetworkAvailable
        
        if sendWakeOnLan {
            beginWakeServer(server)
        }
        
        let wakeOnLanSendTime = NSDate().timeIntervalSince1970
        testNextConnectionMode(tests: tests,
            index: 0,
            localNetworkAvailable: localNetworkAvailable,
            server: server,
            wakeOnLanSendTime: wakeOnLanSendTime,
            options: options,
            onSuccess: onSuccess,
            onError: onError)
    }
    
    private func connect( servers: [ServerInfo], onSuccess: @escaping (ConnectionResult) -> Void, onError: @escaping (Error) -> Void) {
        
        var servers = servers
        servers.sort {
            if let date1 = $0.dateLastAccessed, let date2 = $1.dateLastAccessed {
                return date1.compare(date2 as Date) == ComparisonResult.orderedDescending
            } else if let _ = $1.dateLastAccessed {
                return false
            } else {
                return true
            }
        }
        
        if servers.count == 1 {
            connect(server: servers[0], onSuccess: { (result) -> Void in
                var newResult = result
                if newResult.state == .Unavailable {
                    newResult.state = result.connectUser == nil ? .ConnectSignIn : .ServerSelection
                }
                
                onSuccess(newResult)
                }, onError: { (error) -> Void in
                    onError(error)
            })
            return
        }
        
        // See if we have any saved credentials and can auto sign in
        if !servers.isEmpty && servers[0].accessToken != nil {
            let firstServer = servers[0]
            connect(server: firstServer, onSuccess: { (result) -> Void in
                if result.state == .SignedIn {
                    onSuccess(result)
                }
                else {
                    var newResult = ConnectionResult()
                    newResult.servers = servers
                    newResult.state = .ConnectSignIn
                    newResult.connectUser = self.connectUser
                    onSuccess(newResult)
                }
                }, onError: { (error) -> Void in
                    onError(error)
            })
            return
        }
        
        if servers.isEmpty || servers[0].accessToken == nil {
            var result = ConnectionResult()
            result.servers = servers
            result.connectUser = connectUser
            result.state = servers.isEmpty ? .ConnectSignIn : .ServerSelection
            onSuccess(result)
        }
    }
    
    public func connect(address: String, onSuccess: @escaping (ConnectionResult) -> Void, onError: @escaping (Error) -> Void) {
        let normalizedAddress = normalizeAddress(address: address)
        
        tryConnect(url: normalizedAddress, timeout: 1500, onSuccess: { (systemInfo) -> Void in
            
            let server = ServerInfo()
            server.manualAddress = normalizedAddress
            server.lastConnectionMode = .Manual
            server.importInfo(systemInfo: systemInfo)
            
            self.connect(server: server, onSuccess: onSuccess, onError: onError)
            
        }, onError: { (error) -> Void in
            var result = ConnectionResult()
            result.state = .Unavailable
            result.connectUser = self.connectUser
            onSuccess(result)
        })
    }
    
    func testNextConnectionMode(tests: [ConnectionMode],
        index: Int,
        localNetworkAvailable: Bool,
        server: ServerInfo,
        wakeOnLanSendTime: TimeInterval,
        options: ConnectionOptions,
        onSuccess: @escaping (ConnectionResult) -> Void,
        onError: @escaping (Error) -> Void)
    {
        
        if index >= tests.count {
            let result = ConnectionResult()
            onSuccess(result)
            return
        }
        
        let mode = tests[index]
        let address = server.getAddress(mode: mode)
        
        var enableRetry = false
        var skipTest = false
        var timeout = 15000
        
        if mode == .Local {
            
            if !localNetworkAvailable {
                print("Skipping local connection test because local network is unavailable")
                skipTest = true
            }
            enableRetry = true
            timeout = 10000
            
        } else if mode == .Manual {
            
            if address == server.localAddress {
                print("Skipping manual connection test because the address is the same as the local address")
                skipTest = true
            } else if address == server.remoteAddress {
                print("Skipping manual connection test because the address is the same as the remote address")
                skipTest = true
            }
        }
        
        let emptyAddress = address == nil || address!.isEmpty
        if skipTest || emptyAddress {
            testNextConnectionMode(tests: tests,
                index: index + 1,
                localNetworkAvailable: localNetworkAvailable,
                server: server,
                wakeOnLanSendTime: wakeOnLanSendTime,
                options: options,
                onSuccess: onSuccess,
                onError: onError)
            return
        }
        
        tryConnect(url: address!, timeout: timeout, onSuccess: { (systemInfo) -> Void in
            self.onSuccessfulConnection(server: server, systemInfo: systemInfo, connectionMode: mode, connectionOptions: options, onSuccess: onSuccess, onError: onError)
        }, onError: {(error) -> Void in
            // TODO: Handle retry
            self.testNextConnectionMode(tests: tests,
                index: index + 1,
                localNetworkAvailable: localNetworkAvailable,
                server: server,
                wakeOnLanSendTime: wakeOnLanSendTime,
                options: options,
                onSuccess: onSuccess,
                onError: onError)
        })
    }
    
    func tryConnect(url: String, timeout: Int, onSuccess: @escaping (PublicSystemInfo) -> Void, onError: @escaping (Error) -> Void) {
        
        let finalURL = url + "/mediabrowser/system/info/public?format=json"
        let request = HttpRequest(url: finalURL, method: .get)
        
        httpClient.sendRequest(request: request, success: onSuccess, failure: onError)
    }
    
    func onSuccessfulConnection(server: ServerInfo,
        systemInfo: PublicSystemInfo,
        connectionMode: ConnectionMode,
        connectionOptions: ConnectionOptions,
        onSuccess: @escaping (ConnectionResult) -> Void,
        onError: @escaping (Error) -> Void)
    {
        
        let credentials = credentialProvider.getCredentials()
        
        if !credentials.connectAccessToken.isEmpty {
            ensureConnectUser(credentials: credentials, onSuccess: { () -> Void in
                
                if server.exchangeToken != nil {
                    self.addAuthenticationInfoFromConnect(server: server, systemInfo: systemInfo, connectionMode: connectionMode, connectionOptions: connectionOptions, credentials: credentials, onSuccess: onSuccess, onError: onError)
                } else {
                    self.afterConnectValidated(server: server, credentials: credentials, systemInfo: systemInfo, connectionMode: connectionMode, verifyLocalAuthentication: true, options: connectionOptions, onSuccess: onSuccess, onError: onError)
                }
                
                }, onError: onError)
        } else {
            afterConnectValidated(server: server, credentials: credentials, systemInfo: systemInfo, connectionMode: connectionMode, verifyLocalAuthentication: true, options: connectionOptions, onSuccess: onSuccess, onError: onError)
        }
    }
    
    func afterConnectValidated(server: ServerInfo,
        credentials: ServerCredentials,
        systemInfo: PublicSystemInfo,
        connectionMode: ConnectionMode,
        verifyLocalAuthentication: Bool,
        options: ConnectionOptions,
        onSuccess: @escaping (ConnectionResult) -> Void,
        onError: @escaping (Error) -> Void)
    {
        if verifyLocalAuthentication && server.accessToken != nil {
            validateAuthentication(server: server, connectionMode: connectionMode, onSuccess: { () -> Void in
                
                self.afterConnectValidated(server: server, credentials: credentials, systemInfo: systemInfo, connectionMode: connectionMode, verifyLocalAuthentication: true, options: options, onSuccess: onSuccess, onError: onError)
                }, onError: { (error) -> Void in
                    onError(error)
            })
        }
        
        server.importInfo(systemInfo: systemInfo)
        
        if options.updateDateLastAccessed {
            server.dateLastAccessed = NSDate()
        }
        
        server.lastConnectionMode = connectionMode
        credentials.addOrUpdateServer(server: server)
        credentialProvider.saveCredentials(credentials: credentials)
        
        var result = ConnectionResult()
        result.apiClient = getOrAddApiClient(server: server, connectionMode: connectionMode)
        result.state = server.accessToken == nil ? .ServerSignIn : .SignedIn
        result.servers.append(server)
        result.apiClient?.enableAutomaticNetworking(info: server, initialMode: connectionMode, networkConnection: networkConnection)
        
        if result.state == .SignedIn {
            afterConnected(apiClient: result.apiClient!, options: options)
        }
        
        onSuccess(result)
    }
    
    func afterConnected(apiClient: ApiClient, options: ConnectionOptions) {
        if options.reportCapabilities {
            // TODO: Uncomment after implementing
            // apiClient.reportCapabilities(clientCapabilities)
        }
        
        if options.enableWebSocket {
            // TODO: Uncomment after implementing
            // apiClient.openWebSocket()
        }
    }
    
    
    // MARK: - Connect Service Methods
    
    func ensureConnectUser(credentials: ServerCredentials, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        
        if let connectUser = connectUser, connectUser.id == credentials.connectUserId {
            onSuccess()
            return
        }
        
        if !credentials.connectUserId.isEmpty && !credentials.connectAccessToken.isEmpty {
            connectUser = nil
            
            var query = ConnectUserQuery()
            query.id = credentials.connectUserId
            
            
            do {
                
                try connectService.GetConnectUser(query: query, connectAccessToken: credentials.connectAccessToken, success: { (user) -> Void in
                    
                    self.onConnectUserSignIn(user: user)
                    onSuccess()
                    
                }, failure: onError)
                
            } catch {
                onError(error)
            }
            
        }
    }
    
    func addAuthenticationInfoFromConnect(server: ServerInfo,
        systemInfo: PublicSystemInfo,
        connectionMode: ConnectionMode,
        connectionOptions: ConnectionOptions,
        credentials: ServerCredentials,
        onSuccess: @escaping (ConnectionResult) -> Void,
        onError: @escaping (Error) -> Void)
    {
        guard var url = server.getAddress(mode: connectionMode) else {
            preconditionFailure("Illegal Argument: No address for connection mode")
        }
        guard let exchangeToken = server.exchangeToken else {
            preconditionFailure("Illegal Argument: server")
        }
        
        print("Adding authentication info from Connect")
        
        url += "/emby/Connect/Exchange?format=json&ConnectUserId=" + credentials.connectUserId
        
        let request = HttpRequest(url: url, method: .get)
        request.headers["X-MediaBrowser-Token"] = exchangeToken
        
        httpClient.sendRequest(request: request, success: { (result: ConnectAuthenticationExchangeResult) -> Void in
            
            server.userId = result.localUserId
            server.accessToken = result.accessToken
            self.afterConnectValidated(server: server, credentials: credentials, systemInfo: systemInfo, connectionMode: connectionMode, verifyLocalAuthentication: true, options: connectionOptions, onSuccess: onSuccess, onError: onError)
            
        }, failure: onError)
    }
    
    func validateAuthentication(server: ServerInfo, connectionMode: ConnectionMode, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        
        let url = server.getAddress(mode: connectionMode)!
        
        let headers = HttpHeaders()
        headers.setAccessToken(token: server.accessToken)
        
        var request = HttpRequest(url: url + "/system/info?format=json", method: .get)
        request.headers = headers
        
        httpClient.sendRequest(request: request, success: { (info: SystemInfo) -> Void in
            
            server.importInfo(systemInfo: info)
            
            if server.userId != nil {
                
                let request = HttpRequest(url: url + "/mediabrowser/users/\(String(describing: server.userId))?format=json", method: .get)
                self.httpClient.sendRequest(request: request, success: { (user: UserDto) -> Void in
                    
                    self.onLocalUserSignIn(user: user)
                    onSuccess()
                    
                    }, failure: onError)

            } else {
                onSuccess()
            }
            
            }, failure: onError)
    }
    
    func onAuthenticated(apiClient: ApiClient, result: AuthenticationResult, options: ConnectionOptions, saveCredentials: Bool) {
        
        print("Updating credentials after local authentication")
        
        // TODO: Replace once implemented in ApiClient
        // let server: ServerInfo = apiClient.getServerInfo()
        let server = ServerInfo()
        
        let credentials = credentialProvider.getCredentials()
        
        if options.updateDateLastAccessed {
            server.dateLastAccessed = NSDate()
        }
        
        if saveCredentials {
            server.userId = result.user.id!
            server.accessToken = result.accessToken
        } else {
            //server.userId = nil
            //server.accessToken = nil
        }
        
        credentials.addOrUpdateServer(server: server)
        saveUserInfoIntoCredentials(server: server, user: result.user)
        credentialProvider.saveCredentials(credentials: credentials)
        
        afterConnected(apiClient: apiClient, options: options)
        
        onLocalUserSignIn(user: result.user)
    }
    
    public func loginToConnect(username: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        
        connectService.Authenticate(username: username, password: password, success: { (result) -> Void in
            
            let credentials = self.credentialProvider.getCredentials()
            credentials.connectAccessToken = result.accessToken
            credentials.connectUserId = result.user.id
            self.credentialProvider.saveCredentials(credentials: credentials)
            
            self.onConnectUserSignIn(user: result.user)
            
            onSuccess()
            
            }, failure: onError)
    }
    
    // MARK: - Server PIN Methods
    
    public func createPin(deviceId: String, onSuccess: @escaping (PinCreationResult) -> Void, onError: @escaping (Error) -> Void) {
        connectService.CreatePin(deviceId: deviceId, success: onSuccess, failure: onError)
    }
    
    public func getPinStatus(pin: PinCreationResult, onSuccess: @escaping (PinStatusResult) -> Void, onError: @escaping (Error) -> Void) {
        connectService.GetPinStatus(pin: pin, success: onSuccess, failure: onError)
    }
    
    public func exchangePin(pin: PinCreationResult, onSuccess: @escaping (PinExchangeResult) -> Void, onError: @escaping (Error) -> Void) {
        connectService.ExchangePin(pin: pin, success: { (result) -> Void in
            
            let credentials = self.credentialProvider.getCredentials()
            credentials.connectAccessToken = result.accessToken
            credentials.connectUserId = result.userId
            self.credentialProvider.saveCredentials(credentials: credentials)
            
            onSuccess(result)
            
            }, failure: onError)
    }
    
    public func getRegistrationInfo(featureName: String, connectedServerId: String, onSuccess: @escaping (RegistrationInfo) -> Void, onError: @escaping (Error) -> Void) {
        
        serverDiscovery.findServers(timeoutMs: 1000, onSuccess: { (servers) -> Void in
            
            var serverInfoList: [ServerInfo] = []
            
            for server in servers {
                let serverInfo = ServerInfo()
                
                serverInfo.localAddress = server.address
                serverInfo.id = server.id
                serverInfo.name = server.name
                
                serverInfoList.append(serverInfo)
            }
            
            // TODO: Once getRegistrationInfo() is implemented in ApiClient
            for serverInfo in serverInfoList {
                if serverInfo.id == connectedServerId {
                    if let apiClient = self.getApiClient(serverId: serverInfo.id) {
                        //apiClient.getRegistrationInfo(featureName)
                    }
                }
            }
            
            let credentials = self.credentialProvider.getCredentials()
            
            if !credentials.connectAccessToken.isEmpty && !credentials.connectUserId.isEmpty {
                
                do {
                    try self.connectService.GetRegistrationInfo(userId: credentials.connectUserId, feature: featureName, connectAccessToken: credentials.connectAccessToken, success: onSuccess, failure: onError)
                } catch {
                    onError(NSError(domain: "com.emby.apiclient", code: 1, userInfo: nil))
                }
                
            } else {
                
            }
            
            
        }) { (error) -> Void in
            
        }
    }
    
    // MARK: - Logging Out
    
    public func logout(onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        print("Logging out of all servers")
        
        logoutAll(onSuccess: onSuccess, onError: onError)
    }
    
    func logoutAll(onSuccess: () -> Void, onError: () -> Void) {
        // TODO: Implement once ApiClient can logout
        
//        let clientList = apiClients.values
//        
//        for client in clientList {
//            client.logout()
//        }
        
        connectUser = nil
    }
    
    
    // MARK: - Waking Servers
    
    func wakeAllServers() {
        print("Waking all servers")
        
        for server in credentialProvider.getCredentials().servers {
            wakeServer(server)
        }
    }
    
    func beginWakeServer(_ server: ServerInfo) {
        
        let wakeList = server.wakeOnLanInfos
        for info in wakeList {
            wakeServer(info: info)
        }
        
        print("Waking server: \(server.name), ID: \(server.id), number: \(wakeList.count)")
    }
    
    func wakeServer(_ server: ServerInfo) {
        for info in server.wakeOnLanInfos {
            wakeServer(info: info)
        }
    }
    
    func wakeServer(info: WakeOnLanInfo) {
        networkConnection.sendWakeOnLan(macAddress: info.macAddress, port: info.port)
    }
    
    
    // MARK: - Utility Methods
    
    public func getApiClient(item: IHasServerId) -> ApiClient? {
        return getApiClient(serverId: item.serverId)
    }
    
    public func getApiClient(serverId: String) -> ApiClient? {
        return apiClients[serverId]
    }
    
    public func getServerInfo(serverId: String) -> ServerInfo? {
        return credentialProvider
            .getCredentials()
            .servers
            .filter({$0.id == serverId})
            .first
    }
    
    func getOrAddApiClient(server: ServerInfo, connectionMode: ConnectionMode) -> ApiClient {
        
        var apiClient = apiClients[server.id]
        
        if apiClient == nil {
            
            let address = server.getAddress(mode: connectionMode)!
            
            apiClient = ApiClient(httpClient: httpClient, jsonSerializer: JsonSerializer(), logger: Logger(), serverAddress: address, appName: "Emby_ApiClient", applicationVersion: "1.0", device: device)
            
            apiClients[server.id] = apiClient
            
            // TODO: Add observer
            // apiClient.getAuthenticatedObservable().addObserver(new AuthenticatedObserver(this, apiClient))
        }
        
        if server.accessToken == nil {
            apiClient!.clearAuthenticationInfo()
        } else {
            apiClient!.setAuthenticationInfo(accessToken: server.accessToken, userId: server.userId)
        }
        
        return apiClient!
    }
    
    func onConnectUserSignIn(user: ConnectUser) {
        connectUser = user
    }
    
    func onLocalUserSignIn(user: UserDto) {
        // TODO: Fire event
    }
    
    func onLocalUserSignOut(user: UserDto) {
        // TODO: Fire event
    }
    
    func saveUserInfoIntoCredentials(server: ServerInfo, user: UserDto) {
        let info = ServerUserInfo(id: user.id!, isSignedInOffline: true)
        server.addOrUpdate(user: info)
    }
    
    func normalizeAddress(address: String) -> String {
        precondition(!address.isEmpty, "Illegal Argument: address")
        
        if !address.hasPrefix("http") {
            return "http://" + address
        }
        
        return address
    }
}
