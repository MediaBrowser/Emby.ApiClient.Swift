//
//  INetworkConnection.swift
//  EmbyApiClient
//

import Foundation

public protocol INetworkConnection {
    
    func sendWakeOnLan(macAddress: String, port: Int)
    func sendWakeOnLan(macAddress: String, ipAddress: String, port: Int)
    func getNetworkStatus() -> NetworkStatus
}

//public enum NetworkStatus {
//    case Unavailable
//    case Available
//    case AvailableLocally
//    
//    public var anyLocalNetworkAvailable: Bool {
//        return !(self == .Unavailable)
//    }
//}