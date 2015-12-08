//
//  DirectPlayProfile.swift
//  EmbyApiClient
//

import Foundation

public struct DirectPlayProfile {
    let container: String?
    let audioCodec: String?
    let videoCodec: String?
    var type = DlnaProfileType.Audio
    var containers: [String] {
        get {
            return splitToArray(container, delimiter: ",")
        }
    }
    var audioCodecs: [String] {
        get {
            return splitToArray(audioCodec, delimiter: ",")
        }
    }
    var videoCodecs: [String] {
        get {
            return splitToArray(videoCodec, delimiter: ",")
        }
    }
}