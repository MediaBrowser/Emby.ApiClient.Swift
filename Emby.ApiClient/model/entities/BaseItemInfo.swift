//
//  BaseItemInfo.swift
//  EmbyApiClient
//

import Foundation

public struct BaseItemInfo {
    var name: String?
    var id: String?
    var type: String?
    var mediaType: String?
    var runTimeTicks: Int?
    var primaryImageTag: String?
    var primaryImageItemId: String?
    var logoImageTag: String?
    var logoItemId: String?
    var thumbImageTag: String?
    var thumbItemId: String?
    var backdropImageTag: String?
    var backdropItemId: String?
    var premiereDate: NSDate?
    var productionYear: Int?
    var indexNumber: Int?
    var indexNumberEnd: Int?
    var parentIndexNumber: Int?
    var seriesName: String?
    var album: String?
    var artists = [String]()
    var mediaStreams = [MediaStream]()
    var chapters = [ChapterInfoDto]()
    var hasPrimaryImage: Bool {
        get {
            return primaryImageTag != nil
        }
    }
}