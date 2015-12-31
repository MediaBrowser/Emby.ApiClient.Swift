//
//  PlayerStateInfo.swift
//  EmbyApiClient
//

import Foundation

public struct PlayerStateInfo : JSONSerializable {
    let positionTicks: Int?
    let canSeek: Bool
    let isPaused: Bool
    let isMuted: Bool
    let volumeLevel: Int?
    let audioStreamIndex: Int?
    let subtitleStreamIndex: Int?
    let mediaSourceId: String?
    let playMethod: PlayMethod?
    var repeatMode = RepeatMode.RepeatNone
    
    public init?(jSON: JSON_Object) {
        if  let canSeek = jSON["CanSeek"] as? Int,
            let isPaused = jSON["IsPaused"] as? Int,
            let isMuted = jSON["IsMuted"] as? Int,
            let repeatMode = RepeatMode(rawValue: (jSON["RepeatMode"] as? String)!)
        {
            self.positionTicks = jSON["PositionTicks"] as? Int
            self.canSeek = Bool(canSeek)
            self.isPaused = Bool(isPaused)
            self.isMuted = Bool(isMuted)
            self.volumeLevel = jSON["VolumeLevel"] as? Int
            self.audioStreamIndex = jSON["AudioStreamIndex"] as? Int
            self.mediaSourceId = jSON["MediaSourceId"] as? String
            
            if let playMethod = jSON["PlayMethod"] as? Int {
                self.playMethod = PlayMethod(rawValue: playMethod)
            } else {
                self.playMethod = nil
            }
            
            self.repeatMode = repeatMode
            self.subtitleStreamIndex = jSON["SubtitleStreamIndex"] as? Int
        }
        else {
            return nil
        }
    }
}