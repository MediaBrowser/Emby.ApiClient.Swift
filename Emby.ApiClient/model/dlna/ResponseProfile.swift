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
