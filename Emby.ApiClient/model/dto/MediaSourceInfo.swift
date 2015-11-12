//
//  MediaSourceInfo.swift
//  Emby.ApiClient
//

import Foundation

public struct MediaSourceInfo {
    var mediaProtocol: MediaProtocol?
    var id: String?
    var path: String?
    var type: MediaSourceType?
    var container: String?
    var size: Int?
    var name: String?
    var runTimeTicks: Int?
    var readAtNativeFramerate: Bool?
    var supportsTranscoding: Bool = true
    var supportsDirectStream: Bool = true
    var supportsDirectPlay: Bool = true
    var requiresOpening: Bool?
    var openToken: String?
    var requiresClosing: Bool?
    var liveStreamId: String?
    var bufferMs: Int?
    var videoType: VideoType?
    var isoType: IsoType?
    var video3dFormat: Video3DFormat?
    var mediaStreams: [MediaStream] = [MediaStream]()
    var playableStreamFileNames: [String] = [String]()
    var formats: [String] = [String]()
    var bitrate: Int?
    var timestamp: TransportStreamTimestamp?
    var requiredHttpHeaders: [String: String] = [String: String]()
    var transcodingUrl: String?
    var transcodingSubProtocol: String?
    var transcodingContainer: String?
    var defaultAudioStreamIndex: Int?
    var defaultSubtitleStreamIndex: Int?
    var defaultAudioStream: MediaStream? {
        get {
            return getDefaultAudioStream(defaultAudioStreamIndex)
        }
    }
    
    public func getDefaultAudioStream(defaultIndex: Int?) -> MediaStream? {
        if let dIndex = defaultIndex {
            return mediaStreams
                .filter({ $0.type == MediaStreamType.Audio && $0.index == dIndex})
                .first
        }
        
        let mediaS1 = mediaStreams
            .filter({ $0.type == MediaStreamType.Audio && $0.isDefault != nil && $0.isDefault!})
            .first
        
        if let mS1 = mediaS1 {
            return mS1
        }
        
        let mediaS2 = mediaStreams
            .filter({ $0.type == MediaStreamType.Audio})
            .first
        
        if let mS2 = mediaS2 {
            return mS2
        }
        
        return nil
    }
    
    var videoStream: MediaStream? {
        get {
            return mediaStreams
                .filter({ $0.type != nil && $0.type == MediaStreamType.Video && $0.codec?.lowercaseString.rangeOfString("jpeg") == nil})
                .first
        }
    }
    
    public func getMediaStream(type: MediaStreamType, index: Int) -> MediaStream? {
        return mediaStreams
            .filter({ $0.type != nil && $0.type == type && $0.index == index})
            .first
    }
    
    public func getStreamCount(type: MediaStreamType) -> Int? {
        return mediaStreams
            .filter({ $0.type != nil && $0.type! == type })
            .count
    }
    
    public func isSecondaryAudio(stream: MediaStream) -> Bool? {
        return mediaStreams
            .filter({$0.type != nil && $0.type! == MediaStreamType.Audio})
            .contains({$0.index != stream.index})
    }
}