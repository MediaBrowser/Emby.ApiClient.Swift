//
//  ServerInfo.swift
//  Emby.ApiClient
//

import Foundation

public class ServerInfo {
    var users = [ServerUserInfo]()
    var name: String = ""
    var id: String = ""
    var localAddress: String?
    var remoteAddress: String?
    var manualAddress: String?
    var userId: String = ""
    var accessToken: String = ""
    var wakeOnLanInfos = [WakeOnLanInfo]()
    var dateLastAccessed: NSDate?
    var exchangeToken: String = ""
    var userLinkType: UserLinkType?
    var lastConnectionMode: ConnectionMode?
    
    init() {
        
    }

    func importInfo(systemInfo: PublicSystemInfo) {
        name = systemInfo.serverName
        id = systemInfo.id
        
        localAddress = systemInfo.localAddress
        remoteAddress = systemInfo.wanAddress
        
        if let fullSystemInfo = systemInfo as? SystemInfo {
                wakeOnLanInfos.append(WakeOnLanInfo(macAddress: fullSystemInfo.macAddress))
        }
    }
    
    func getAddress(mode: ConnectionMode) -> String? {
        switch mode {
        case .Local:
            return localAddress
        case .Manual:
            return manualAddress
        case .Remote:
            return remoteAddress
        }
    }
    
    func addOrUpdate(user: ServerUserInfo) {
        //TODO
    }
}