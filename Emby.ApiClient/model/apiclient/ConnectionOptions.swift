//
//  ConnectionOptions.swift
//  Emby.ApiClient
//


import Foundation

public struct ConnectionOptions {
    public var enableWebSocket: Bool
    public var reportCapabilities: Bool
    public var updateDateLastAccessed: Bool
    
    public init(enableWebSocket: Bool, reportCapabilities: Bool, updateDateLastAccessed: Bool) {
        self.enableWebSocket = enableWebSocket
        self.reportCapabilities = reportCapabilities
        self.updateDateLastAccessed = updateDateLastAccessed
    }
    
    public init() {
        self.enableWebSocket = true
        self.reportCapabilities = true
        self.updateDateLastAccessed = true
    }
}