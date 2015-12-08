//
//  DeviceProfile.swift
//  Emby.ApiClient
//

import Foundation

public struct DeviceProfile {
    var name: String?
    var id: String?
    var profileType = DeviceProfileType.System
    var identification: DeviceIdentification?
    var friendlyName: String?
    var manufacturer: String?
    var manufacturerUrl: String?
    var modelName: String?
    var modelDescription: String?
    var modelNumber: String?
    var modelUrl: String?
    var serialNumber: String?
    var enableAlbumArtInDidl: Bool?
    var enableSingleAlbumArtLimit: Bool?
    var supportedMediaType = "[Audio,Photo,Video]"
    var userId: String?
    var albumArtPn: String?
    var maxAlbumArtWidth: Int?
    var maxAlbumArtHeight: Int?
    var maxIconWidth: Int?
    var maxIconHeight: Int?
    var maxStreamingBitrate = 80000000
    var maxStaticBitrate = 80000000
    var musicStreamingTranscodingBitrate = 128000
    var musicSyncBitrate = 128000
    var xDlnaDoc: String?
    var xDlnaCap: String?
    var sonyAggregationFlags: String?
    var protocolInfo: String?
    var timelineOffsetSeconds: Int?
    var requiresPlainVideoItems: Bool?
    var requiresPlainFolders: Bool?
    var enableMSMediaReceiverRegistrar: Bool?
    var ignoreTranscodeByteRangeRequests: Bool?
    var enableDlnaProtocol: Bool?
    var xmlRootAttributes = [XmlAttribute]()
    var directPlayProfiles = [DirectPlayProfile]()
    var transcodingProfiles = [TranscodingProfile]()
    var containerProfiles = [ContainerProfile]()
    var codecProfiles = [CodecProfile]()
    var responseProfiles = [ResponseProfile]()
    var subtitleProfiles = [SubtitleProfile]()
    var supportedMediaTypes: [String] {
        get {
            return splitToArray(supportedMediaType, delimiter: ",")
        }
    }
    
    //TODO audioTranscodingProfile
    //TODO videoTranscodingProfile
    //TODO audioMediaProfile
    //TODO imageMediaProfile
    //TODO videoMediaProfile
}
