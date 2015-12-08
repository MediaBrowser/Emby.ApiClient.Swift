//
//  ResponseProfile.swift
//  EmbyApiClient
//

import Foundation

public struct ResponseProfile {
    let container: String?
    let audioCodec: String?
    let videoCodec: String?
    var type = DlnaProfileType.Audio
    let orgPn: String?
    let mimeType: String?
    var conditions = [ProfileCondition]()
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