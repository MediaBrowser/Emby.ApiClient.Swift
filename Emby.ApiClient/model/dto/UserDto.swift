//
//  UserDto.swift
//  Emby.ApiClient
//

import Foundation

public struct UserDto {
    var name: String?
    var serverId: String?
    var serverName: String?
    var connectUserName: String?
    var connectUserId: String?
    var connectLinkType: UserLinkType?
    var id: String?
    var offlinePassword: String?
    var offlinePasswordSalt: String?
    var primaryImageTag: String?
    var hasPassword: Bool?
    var hasConfiguredPassword: Bool?
    var hasConfiguredEasyPassword: Bool?
    var lastLoginDate: NSDate?
    var lastActivityDate: NSDate?
    let configuration = UserConfiguration()
    let policy = UserPolicy()
    var primaryImageAspectRation: Double?
    var originalPrimaryImageAspectRatio: Double?
    var hasPrimaryImage: Bool? {
        get {
            return primaryImageTag != nil
        }
    }
    
}