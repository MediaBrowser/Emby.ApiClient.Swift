//
//  ConnectionManagerProtocol.swift
//  Emby.ApiClient
//

import Foundation

public protocol ConnectionManagerProtocol {
    func getApiClient(item: IHasServerId) -> ApiClient?
    func getApiClient(serverId: String) -> ApiClient?
    func getServerInfo(serverId: String) -> ServerInfo?
    func connect(onSuccess: (ConnectionResult) -> Void, onError: (ErrorType) -> Void)
    func connect(server: ServerInfo, onSuccess: (ConnectionResult) -> Void, onError: (ErrorType) -> Void)
    func connect(server: ServerInfo, options: ConnectionOptions, onSuccess: (ConnectionResult) -> Void, onError: (ErrorType) -> Void)
    func connect(address: String, onSuccess: (ConnectionResult) -> Void, onError: (ErrorType) -> Void)
    func logout(onSuccess: () -> Void, onError: () -> Void)
    func getAvailableServers(onSuccess: ([ServerInfo]) -> Void, onError: (ErrorType?) -> Void)
    func loginToConnect(username: String, password: String, onSuccess: () -> Void, onError: () -> Void)
    func createPin(deviceId: String, onSuccess: (PinCreationResult) -> Void, onError: (ErrorType) -> Void)
    func getPinStatus(pin: PinCreationResult, onSuccess: (PinStatusResult) -> Void, onError: (ErrorType) -> Void)
    func exchangePin(pin: PinCreationResult, onSuccess: (PinExchangeResult) -> Void, onError: (ErrorType) -> Void)
    func getResgistrationInfo(featureName: String, connectedServerId: String, onSuccess: (RegistrationInfo) -> Void, onError: (ErrorType) -> Void)
}