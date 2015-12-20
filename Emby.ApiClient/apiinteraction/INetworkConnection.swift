//
//  INetworkConnection.swift
//  EmbyApiClient
//

import Foundation

public protocol INetworkConnection {
    func sendWakeOnLan(macAddress: String, port: Int, response: EmptyResponse)
    func sendWakeOnLan(macAddress: String, ipAddress: String, port: Int, response: EmptyResponse)
    func networkStatus() -> NetworkStatus
}