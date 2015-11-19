//
//  ServerCredentials.swift
//  Emby.ApiClient
//

import Foundation

public class ServerCredentials {
    var servers = [ServerInfo]()
    let connectUserId: String
    let connectAccessToken: String

    init(connectAccessToken: String, connectUserId: String) {
        self.connectAccessToken = connectAccessToken
        self.connectUserId = connectUserId
    }
    
    func addOrUpdateServer(server: ServerInfo!) {
        if ( servers.contains(server)) {
            let index = servers.indexOf(server)!
            
            let existingServer = servers[index]

            if let serverDateLastAccessed = server.dateLastAccessed {
                if let existingLastDateAccessed = existingServer.dateLastAccessed {
                    if ( existingLastDateAccessed.compare(serverDateLastAccessed) == NSComparisonResult.OrderedDescending) {
                        existingServer.dateLastAccessed = serverDateLastAccessed
                    }
                } else {
                    existingServer.dateLastAccessed = serverDateLastAccessed
                }
            }
            
            if let serverUserLinkType = server.userLinkType {
                existingServer.userLinkType = serverUserLinkType

            }
            
            if ( !server.accessToken.isEmpty ) {
                existingServer.accessToken = server.accessToken
            }
            
            if ( !server.userId.isEmpty ) {
                existingServer.userId = server.userId

            }
            
            if ( !server.exchangeToken.isEmpty ) {
                existingServer.exchangeToken = server.exchangeToken

            }
            
            if let serverRemoteAddress = server.remoteAddress where !serverRemoteAddress.isEmpty {
                    existingServer.remoteAddress = serverRemoteAddress
            }

            if let serverLocalAddress = server.localAddress where !serverLocalAddress.isEmpty {
                existingServer.localAddress = serverLocalAddress
            }
 
            if let serverManualAddress = server.manualAddress where !serverManualAddress.isEmpty {
                existingServer.manualAddress = serverManualAddress
            }
            
            if ( !server.name.isEmpty ) {
                existingServer.name = server.name
            }
            
            if ( server.wakeOnLanInfos.count > 0 ) {
                existingServer.wakeOnLanInfos.removeAll()
                existingServer.wakeOnLanInfos.appendContentsOf(server.wakeOnLanInfos)
            }
        } else {
            servers.append(server)
        }
    }
}