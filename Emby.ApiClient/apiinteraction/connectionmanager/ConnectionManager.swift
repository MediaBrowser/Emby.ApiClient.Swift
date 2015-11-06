//
//  ConnectionManager.swift
//  Emby.ApiClient
//


import Foundation

public class ConnectionManager: ConnectionManagerProtocol {
    let clientCapabilities: ClientCapabilities
    let apiClients = [String: ApiClient]()
    let credentialProvider: CredentialProviderProtocol
    let device: IDevice
    let serverDiscovery: ServerDiscoveryProtocol

    public init(clientCapabilities: ClientCapabilities,
        credentialProvider: CredentialProviderProtocol,
        device: IDevice,
        serverDiscovery: ServerDiscoveryProtocol) {
            
        self.clientCapabilities = clientCapabilities
        self.credentialProvider = credentialProvider
        self.device = device
        self.serverDiscovery = serverDiscovery
    }

    public func getApiClient(item: IHasServerId) -> ApiClient? {
        return getApiClient(item.serverId)
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
    
    public func connect(onSuccess: (ConnectionResult) -> Void, onError: (ErrorType) -> Void) {
        //TODO    
    }
    
    public func connect(server: ServerInfo, onSuccess: (ConnectionResult) -> Void, onError: (ErrorType) -> Void) {
        //TODO
    }
    
    public func connect(server: ServerInfo, options: ConnectionOptions, onSuccess: (ConnectionResult) -> Void, onError: (ErrorType) -> Void) {
        //TODO
    }
    
    public func connect(address: String, onSuccess: (ConnectionResult) -> Void, onError: (ErrorType) -> Void) {
        //TODO
    }
    
    public func logout(onSuccess: () -> Void, onError: () -> Void) {
        //TODO
    }
    
    public func getAvailableServers(onSuccess: ([ServerInfo]) -> Void, onError: (ErrorType) -> Void) {
        //TODO
    }
    
    public func loginToConnect(username: String, password: String, onSuccess: () -> Void, onError: () -> Void) {
        //TODO
    }
    
    public func createPin(deviceId: String, onSuccess: (PinCreationResult) -> Void, onError: (ErrorType) -> Void) {
        //TODO
    }
    
    public func getPinStatus(pin: PinCreationResult, onSuccess: (PinStatusResult) -> Void, onError: (ErrorType) -> Void) {
        //TODO
    }
    
    public func exchangePin(pin: PinCreationResult, onSuccess: (PinExchangeResult) -> Void, onError: (ErrorType) -> Void) {
        //TODO
    }
    
    public func getResgistrationInfo(featureName: String, connectedServerId: String, onSuccess: (RegistrationInfo) -> Void, onError: (ErrorType) -> Void) {
        //TODO
    }
}
