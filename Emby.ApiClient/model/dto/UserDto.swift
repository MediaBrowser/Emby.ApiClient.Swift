//
//  UserDto.swift
//  Emby.ApiClient
//

import Foundation

public struct UserDto : JSONSerializable {
    public var name: String?
    public var serverId: String?
    public var serverName: String?
    public var connectUserName: String?
    public var connectUserId: String?
    public var connectLinkType: UserLinkType?
    public var id: String?
    public var offlinePassword: String?
    public var offlinePasswordSalt: String?
    public var primaryImageTag: String?
    public var hasPassword: Bool?
    public var hasConfiguredPassword: Bool?
    public var hasConfiguredEasyPassword: Bool?
    public var lastLoginDate: NSDate?
    public var lastActivityDate: NSDate?
    public let configuration = UserConfiguration()
    public let policy = UserPolicy()
    public var primaryImageAspectRation: Double?
    public var originalPrimaryImageAspectRatio: Double?
    
    public var hasPrimaryImage: Bool {
        get {
            return primaryImageTag != nil
        }
    }
    
    public init() {
        
    }
    
    public init?(jSON: JSON_Object) {
        self.name = jSON["Name"] as? String
        self.serverId = jSON["ServerId"] as? String
        self.serverName = jSON["ServerName"] as? String
        self.connectUserName = jSON["ConnectUserName"] as? String
        self.connectUserId = jSON["ConnectUserId"] as? String
        self.connectLinkType =  UserLinkType(rawValue: jSON["ConnectLinkType"] as? String ?? "")
        self.id = jSON["Id"] as? String
        self.offlinePassword = jSON["OfflinePassword"] as? String
        self.offlinePasswordSalt = jSON["OfflinePasswordSalt"] as? String
        self.primaryImageTag = jSON["PrimaryImageTag"] as? String
        self.hasPassword = jSON["HasPassword"] as? Bool
        self.hasConfiguredPassword = jSON["HasConfiguredPassword"] as? Bool
        self.hasConfiguredEasyPassword = jSON["HasConfiguredEasyPassword"] as? Bool
        self.lastLoginDate = jSON["LastLoginDate"] as? NSDate
        self.lastActivityDate = jSON["LastActivityDate"] as? NSDate
        self.primaryImageAspectRation = jSON["PrimaryImageAspectRation"] as? Double
        self.originalPrimaryImageAspectRatio = jSON["OriginalPrimaryImageAspectRatio"] as? Double
    }
}