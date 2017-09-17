//
//  ConnectionManagerProtocol.swift
//  Emby.ApiClient
//

import Foundation

public protocol ConnectionManagerProtocol {
    func getApiClient(item: IHasServerId) -> ApiClient?
    func getApiClient(serverId: String) -> ApiClient?
    func getServerInfo(serverId: String) -> ServerInfo?
    func connect(onSuccess: (ConnectionResult) -> Void, onError: (Error) -> Void)
    func connect(server: ServerInfo, onSuccess: (ConnectionResult) -> Void, onError: (Error) -> Void)
    func connect(server: ServerInfo, options: ConnectionOptions, onSuccess: (ConnectionResult) -> Void, onError: (Error) -> Void)
    func connect(address: String, onSuccess: (ConnectionResult) -> Void, onError: (Error) -> Void)
    func logout(onSuccess: () -> Void, onError: () -> Void)
    func getAvailableServers(onSuccess: ([ServerInfo]) -> Void, onError: (Error?) -> Void)
    func loginToConnect(username: String, password: String, onSuccess: () -> Void, onError: (Error) -> Void)
    func createPin(deviceId: String, onSuccess: (PinCreationResult) -> Void, onError: (Error) -> Void)
    func getPinStatus(pin: PinCreationResult, onSuccess: (PinStatusResult) -> Void, onError: (Error) -> Void)
    func exchangePin(pin: PinCreationResult, onSuccess: (PinExchangeResult) -> Void, onError: (Error) -> Void)
    func getRegistrationInfo(featureName: String, connectedServerId: String, onSuccess: (RegistrationInfo) -> Void, onError: (Error) -> Void)
}
