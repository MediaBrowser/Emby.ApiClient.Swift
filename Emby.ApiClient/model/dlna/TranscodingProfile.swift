//
//  TranscodingProfile.swift
//  EmbyApiClient
//

import Foundation

public struct TranscodingProfile {
    let container: String?
    var type = DlnaProfileType.Audio
    let videoCodec: String?
    let audioCodec: String?
    let protocl: String?
    let estimateContentLength: Bool?
    let enableMpegM2TsMode: Bool?
    var transcodeSeekInfo = TranscodeSeekInfo.Auto
    var context = EncodingContext.Streaming
    var audioCodecs: [String] {
        get {
            return splitToArray(stringToSplit: audioCodec, delimiter: ",")
        }
    }
}
