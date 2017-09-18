//
//  ConnectionManagerProtocol.swift
//  Emby.ApiClient
//

import Foundation

public protocol ConnectionManagerProtocol {
    func getApiClient(item: IHasServerId) -> ApiClient?
    func getApiClient(serverId: String) -> ApiClient?
    func getServerInfo(serverId: String) -> ServerInfo?
    func connect(onSuccess: @escaping (ConnectionResult) -> Void, onError: @escaping (Error) -> Void)
    func connect(server: ServerInfo, onSuccess: @escaping (ConnectionResult) -> Void, onError: @escaping (Error) -> Void)
    func connect(server: ServerInfo, options: ConnectionOptions, onSuccess: @escaping (ConnectionResult) -> Void, onError: @escaping (Error) -> Void)
    func connect(address: String, onSuccess: @escaping (ConnectionResult) -> Void, onError: @escaping (Error) -> Void)
    func logout(onSuccess: @escaping () -> Void, onError: @escaping () -> Void)
    func getAvailableServers(onSuccess: @escaping ([ServerInfo]) -> Void, onError: @escaping (Error?) -> Void)
    func loginToConnect(username: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (Error) -> Void)
    func createPin(deviceId: String, onSuccess: @escaping (PinCreationResult) -> Void, onError: @escaping (Error) -> Void)
    func getPinStatus(pin: PinCreationResult, onSuccess: @escaping (PinStatusResult) -> Void, onError: @escaping (Error) -> Void)
    func exchangePin(pin: PinCreationResult, onSuccess: @escaping (PinExchangeResult) -> Void, onError: @escaping (Error) -> Void)
    func getRegistrationInfo(featureName: String, connectedServerId: String, onSuccess: @escaping (RegistrationInfo) -> Void, onError: @escaping (Error) -> Void)
}
