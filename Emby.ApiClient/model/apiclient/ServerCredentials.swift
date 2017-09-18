//
//  ServerCredentials.swift
//  Emby.ApiClient
//

import Foundation

public class ServerCredentials: NSObject, NSCoding {
    public func encode(with aCoder: NSCoder) {
    }
    
    var servers = [ServerInfo]()
    var connectUserId: String
    var connectAccessToken: String

    init(connectAccessToken: String, connectUserId: String, servers: [ServerInfo] = []) {
        self.connectAccessToken = connectAccessToken
        self.connectUserId = connectUserId
        self.servers = servers
    }
    
    func addOrUpdateServer(server: ServerInfo!) {
        if ( servers.contains(server)) {
            let index = servers.index(of: server)!
            
            let existingServer = servers[index]

            if let serverDateLastAccessed = server.dateLastAccessed {
                if let existingLastDateAccessed = existingServer.dateLastAccessed {
                    if ( existingLastDateAccessed.compare(serverDateLastAccessed as Date) == ComparisonResult.orderedDescending) {
                        existingServer.dateLastAccessed = serverDateLastAccessed
                    }
                } else {
                    existingServer.dateLastAccessed = serverDateLastAccessed
                }
            }
            
            if let serverUserLinkType = server.userLinkType {
                existingServer.userLinkType = serverUserLinkType

            }
            
            if ( server.accessToken != nil && !server.accessToken!.isEmpty ) {
                existingServer.accessToken = server.accessToken
            }
            
            if ( server.userId != nil && !server.userId!.isEmpty ) {
                existingServer.userId = server.userId

            }
            
            if ( server.exchangeToken != nil ) {
                existingServer.exchangeToken = server.exchangeToken

            }
            
            if let serverRemoteAddress = server.remoteAddress, !serverRemoteAddress.isEmpty {
                    existingServer.remoteAddress = serverRemoteAddress
            }

            if let serverLocalAddress = server.localAddress, !serverLocalAddress.isEmpty {
                existingServer.localAddress = serverLocalAddress
            }
 
            if let serverManualAddress = server.manualAddress, !serverManualAddress.isEmpty {
                existingServer.manualAddress = serverManualAddress
            }
            
            if ( !server.name.isEmpty ) {
                existingServer.name = server.name
            }
            
            if ( server.wakeOnLanInfos.count > 0 ) {
                existingServer.wakeOnLanInfos.removeAll()
                existingServer.wakeOnLanInfos.append(contentsOf: server.wakeOnLanInfos)
            }
        } else {
            servers.append(server)
        }
    }
    
    // MARK: NSCoding
    
    public required convenience init?(coder aDecoder: NSCoder) {
        guard let connectUserId = aDecoder.decodeObject(forKey: "connectUserId") as? String,
            let connectAccessToken = aDecoder.decodeObject(forKey: "connectAccessToken") as? String,
            let servers = aDecoder.decodeObject(forKey: "servers") as? [ServerInfo]
            else { return nil }
        
        self.init(connectAccessToken: connectAccessToken, connectUserId: connectUserId, servers: servers)
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encode(self.connectUserId, forKey: "connectUserId")
        aCoder.encode(self.connectAccessToken, forKey: "connectAccessToken")
        aCoder.encode(self.servers, forKey: "servers")
    }
}
