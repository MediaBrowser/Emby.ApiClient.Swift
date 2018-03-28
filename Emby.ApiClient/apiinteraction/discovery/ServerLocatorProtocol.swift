//
//  ServerLocatorProtocol.swift
//  EmbyApiClient

import Foundation

public protocol ServerDiscoveryProtocol {
    func findServers(timeoutMs: Int, onSuccess: @escaping ([ServerDiscoveryInfo]) -> Void, onError: @escaping (Error) -> Void)
}
