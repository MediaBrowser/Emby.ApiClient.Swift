//
//  NetworkStatus.swift
//  EmbyApiClient
//

import Foundation

public struct NetworkStatus {
    let networkAvailable: Bool
    let localNetworkAvailable: Bool
    
    var anyLocalNetworkAvailable: Bool {
        return networkAvailable ?? localNetworkAvailable
    }
    
    init(networkAvailable: Bool, localNetworkAvailable: Bool) {
        self.networkAvailable = networkAvailable
        self.localNetworkAvailable = localNetworkAvailable
    }
}