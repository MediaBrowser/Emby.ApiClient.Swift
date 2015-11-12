//
//  MediaStream.swift
//  Emby.ApiClient
//

import Foundation

public struct MediaStream {
    var codec: String?
    var codecTag: String?
    var language: String?
    var isInterlaced: Bool?
    var channelLayout: String?
    var bitrate: Int?
    var bitDepth: Int?
    var refFrames: Int?
    var packetLength: Int?
    var channels: Int?
    var sampleRate: Int?
    var isDefault: Bool?
    var isForced: Bool?
    var height: Int?
    var width: Int?
    var averageFrameRate: Float?
    var realFrameRate: Float?
    var profile: String?
    var type: MediaStreamType?
    var aspectRatio: String?
    var index: Int?
    var score: Int?
    var isExternal: Bool?
    var deliveryMethod: SubtitleDeliveryMethod?
    var deliveryUrl: String?
    var isExternalUrl: Bool?
    var isTextSubtitleStream: Bool {
        get {
            if type != MediaStreamType.Subtitle {
                return false
            }
            
            if codec == nil && isExternal != nil  && !isExternal! {
                return false
            }
            
            return MediaStream.isTextFormat(codec)
        }
    }
    
    public static func isTextFormat(format: String?) -> Bool {
        if let fmt = format {
            return fmt.lowercaseString.rangeOfString("pgs") == nil &&
                fmt.lowercaseString.rangeOfString("dvd") == nil &&
                fmt.caseInsensitiveCompare("sub") != .OrderedSame
        } else {
            return true
        }
    }
    
    var supportsExternalStream: Bool?
    var path: String?
    var externalId: String?
    var pixelFormat: String?
    var level: Double?
    var isAnamorphic: Bool?
    var isCabac: Bool?
    var keyFrames: [Int]?
}