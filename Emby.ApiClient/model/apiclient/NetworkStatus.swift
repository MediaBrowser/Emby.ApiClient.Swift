//
//  NetworkStatus.swift
//  EmbyApiClient
//

import Foundation

public struct NetworkStatus {
    let isNetworkAvailable: Bool?
    let isLocalNetworkAvailable: Bool?
    var isAnyLocalNetworkAvailable: Bool? {
        return isLocalNetworkAvailable ?? isNetworkAvailable
    }
}