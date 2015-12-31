//
//  SessionInfoDto.swift
//  EmbyApiClient
//

import Foundation

public struct SessionInfoDto : JSONSerializable {
      var supportedCommands = [String]()
      var queueableMediaTypes = [String]()
      var playableMediaTypes = [String]()
      let id: String
      let userId: String
      let userPrimaryImageTag: String?
      let userName: String
//    var additionalUsers = [SessionUserInfo]()
      let applicationVersion: String
      let client: String
      var lastActivityDate = NSDate()
//    let nowViewingItem: BaseItemInfo
      let deviceName: String
//    let nowPlayingItem: BaseItemInfo
      let deviceId: String
      let appIconUrl: String?
      let supportsRemoteControl: Bool
      let playState: PlayerStateInfo
//    let transcodingInfo: TranscodingInfo
    
    public init?(jSON: JSON_Object) {
        if  let queueableMediaTypes = jSON["QueueableMediaTypes"] as? [String],
            let playableMediaTypes = jSON["PlayableMediaTypes"] as? [String],
            let deviceId = jSON["DeviceId"] as? String,
            let supportsRemoteControl = jSON["SupportsRemoteControl"] as? Int,
            let userId = jSON["UserId"] as? String,
            let deviceName = jSON["DeviceName"] as? String,
            let id = jSON["Id"] as? String,
            let userName = jSON["UserName"] as? String,
            let playstateJSON = jSON["PlayState"] as? JSON_Object,
            let playState = PlayerStateInfo(jSON: playstateJSON),
            let supportedCommands = jSON["SupportedCommands"] as? [String],
            let client = jSON["Client"] as? String,
            let lastActivityDateString = jSON["LastActivityDate"] as? String,
            let applicationVersion = jSON["ApplicationVersion"] as? String
        {
            self.queueableMediaTypes = queueableMediaTypes
            self.playableMediaTypes = playableMediaTypes
            self.deviceId = deviceId
            self.appIconUrl = jSON["AppIconUrl"] as? String
            self.supportsRemoteControl = Bool(supportsRemoteControl)
            self.userId = userId
            self.userPrimaryImageTag = jSON["UserPrimaryImageTag"] as? String
            self.deviceName = deviceName
            self.id = id
            self.userName = userName
            self.playState = playState
            self.supportedCommands = supportedCommands
            self.client = client
            
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            
            self.lastActivityDate = formatter.dateFromString(lastActivityDateString)!
            self.applicationVersion = applicationVersion
            
            //MARK: TODO Additional Users
            //MARK: TODO Now Viewing Item
            //MARK: TODO Transcoding Info
        }
        else {
            return nil
        }
    }
}