//
//  CredentialProviderProtocol.swift
//  Emby.ApiClient
//

import Foundation

public protocol CredentialProviderProtocol {
    func getCredentials() -> ServerCredentials
    func saveCredentials(credentials: ServerCredentials)
}