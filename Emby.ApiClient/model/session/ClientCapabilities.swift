//
//  ClientCapabilities.swift
//  Emby.ApiClient
//

import Foundation

public struct ClientCapabilities {
    let playableMediaTypes: [String]
    let supportedCommands: [String]
    let supportsMediaControl: Bool
    let messageCallbackUrl: String
    let supportsContentUploading: Bool
    let supportsPersistentIdentifier: Bool
    let supportsSync: Bool
    let supportsOfflineAccess: Bool
    let deviceProfile: DeviceProfile
    let supportedLiveMediaTypes: [String]
    let appStoreUrl: String
    let iconUrl: String
}