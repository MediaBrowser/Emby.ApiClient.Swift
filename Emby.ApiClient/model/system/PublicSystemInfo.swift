//
//  PublicSystemInfo.swift
//  Emby.ApiClient
//

import Foundation

public class PublicSystemInfo {
    let localAddress: String?
    let wanAddress: String?
    let serverName: String
    let version: String
    let operatingSystem: String
    let id: String
    
    init(localAddress: String?, wanAddress: String?, serverName: String, version: String, operatingSystem: String, id: String) {
        self.localAddress = localAddress
        self.wanAddress = wanAddress
        self.serverName = serverName
        self.version = version
        self.operatingSystem = operatingSystem
        self.id = id
    }
}