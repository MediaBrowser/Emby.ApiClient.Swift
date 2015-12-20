//
//  TranscodingInfo.swift
//  EmbyApiClient
//

import Foundation

public struct TranscodingInfo {
    let audioCodec: String?
    let videoCodec: String?
    let container: String?
    let isVideoDirect: Bool?
    let isAudioDirect: Bool?
    let bitrate: Int?
    let framerate: Double?
    let completionPercentage: Double?
    let width: Int?
    let height: Int?
    let audioChannels: Int?
}