//
//  ProfileConditionValue.swift
//  EmbyApiClient
//

import Foundation

public enum ProfileConditionValue: Int {
    case AudioChannels
    case AudioBitrate
    case AudioProfile
    case Width
    case Height
    case Has64BitOffsets
    case PacketLength
    case VideoBitDepth
    case VideoBitRate
    case VideoFramerate
    case VideoLevel
    case VideoProfile
    case VideoTimestamp
    case IsAnamorphic
    case RefFrames
    case IsCabac
    case NumAudioStreams
    case NumVideoStreams
    case IsSecondaryAudio
}