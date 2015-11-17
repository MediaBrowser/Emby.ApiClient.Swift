//
//  UserPolicy.swift
//  Emby.ApiClient
//

import Foundation

public struct UserPolicy {
    var isAdministrator: Bool?
    var isHidden: Bool?
    var isDisabled: Bool?
    var maxParentalRating: Int?
    var blockedTags = [String]()
    var enableUserPreferenceAccess = true
    var accessSchedules = [AccessSchedule]()
    var blockUnratedItems = [UnratedItem]()
    var enableRemoteControlOfOtherUsers: Bool?
    var enableSharedDeviceControl = true
    var enableLiveTvManagement = true
    var enableLiveTvAccess = true
    var enableMediaPlayback = true
    var enableAudioPlaybackTranscoding = true
    var enableVideoPlaybackTranscoding = true
    var enableContentDeletion: Bool?
    var enableContentDownloading = true
    var enableSync = true
    var enableSyncTranscoding = true
    var enabledDevices = [String]()
    var enableAllDevices = true
    var enabledChannels = [String]()
    var enableAllChannels = true
    var enabledFolders = [String]()
    var enableAllFolders = true
    var invalidLoginAttemptCount: Int?
    var enablePublicSharing = true
    var blockedMediaFolders: [String]?
    var blockedChannels: [String]?
}