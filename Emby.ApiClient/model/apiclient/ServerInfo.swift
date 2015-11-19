//
//  ServerInfo.swift
//  Emby.ApiClient
//

import Foundation

public class ServerInfo: Hashable {
    var users = Set<ServerUserInfo>()
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
    public var hashValue: Int {
        get {
            return id.hashValue
        }
    }
    
    func importInfo(systemInfo: PublicSystemInfo) {
        name = systemInfo.serverName
        id = systemInfo.id
        
        if let lAddress = systemInfo.localAddress where !lAddress.isEmpty {
            localAddress = lAddress
        }
        
        if let wAddress = systemInfo.wanAddress where !wAddress.isEmpty {
            remoteAddress = wAddress
        }
        
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
        if ( users.contains(user)) {
            users.remove(user)
        }
        
        users.insert(user)
    }
}

//MARK: - Equatable
public func ==(lhs: ServerInfo, rhs: ServerInfo) -> Bool {
    return lhs.id == rhs.id
}