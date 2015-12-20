//
//  PlayerStateInfo.swift
//  EmbyApiClient
//

import Foundation

public struct PlayerStateInfo {
    let positionTicks: Int
    let canSeek: Bool
    let isPaused: Bool
    let isMuted: Bool
    let volumeLevel: Int
    let audioStreamIndex: Int
    let subtitleStreamIndex: Int
    let mediaSourceId: String
    let playMethod: PlayMethod
    let repeatMode = RepeatMode.RepeatNone
}