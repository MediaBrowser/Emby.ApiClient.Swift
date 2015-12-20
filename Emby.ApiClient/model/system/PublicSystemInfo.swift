//
//  PublicSystemInfo.swift
//  Emby.ApiClient
//

import Foundation

public class PublicSystemInfo: JSONSerializable {
    let localAddress: String?
    let wanAddress: String?
    let serverName: String
    let version: String
    let operatingSystem: String
    let id: String
    
    // TODO: Handle JSON
    public required init?(jSON: JSON_Object) {
        if  let serverName = jSON["ServerName"] as? String,
            let version = jSON["Version"] as? String,
            let operatingSystem = jSON["OperatingSystem"] as? String,
            let id = jSON["Id"] as? String
        {
            self.serverName = serverName
            self.version = version
            self.operatingSystem = operatingSystem
            self.id = id
            
            self.localAddress = jSON["LocalAddress"] as? String
            self.wanAddress = jSON["WanAddress"] as? String
        }
        else {
            self.serverName = ""
            self.version = ""
            self.operatingSystem = ""
            self.id = ""
            self.localAddress = nil
            self.wanAddress = nil
            
            return nil
        }
    }
    
    init(localAddress: String?, wanAddress: String?, serverName: String, version: String, operatingSystem: String, id: String) {
        self.localAddress = localAddress
        self.wanAddress = wanAddress
        self.serverName = serverName
        self.version = version
        self.operatingSystem = operatingSystem
        self.id = id
    }
}