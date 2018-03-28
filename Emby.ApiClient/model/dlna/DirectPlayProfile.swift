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
            return splitToArray(stringToSplit: container, delimiter: ",")
        }
    }
    var audioCodecs: [String] {
        get {
            return splitToArray(stringToSplit: audioCodec, delimiter: ",")
        }
    }
    var videoCodecs: [String] {
        get {
            return splitToArray(stringToSplit: videoCodec, delimiter: ",")
        }
    }
}
