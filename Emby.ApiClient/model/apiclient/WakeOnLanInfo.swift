//
//  WakeOnLanInfo.swift
//  Emby.ApiClient
//

import Foundation

public struct WakeOnLanInfo {
    let macAddress: String
    let port: Int
    
    init(macAddress: String) {
        self.macAddress = macAddress
        self.port = 0
    }
}