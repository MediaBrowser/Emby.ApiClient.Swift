//
//  ServerLocatorProtocol.swift
//  EmbyApiClient

import Foundation

public protocol ServerDiscoveryProtocol {
    func findServers(timeoutMs: Int, onSuccess: ([ServerDiscoveryInfo]) -> Void, onError: (ErrorType) -> Void)
}