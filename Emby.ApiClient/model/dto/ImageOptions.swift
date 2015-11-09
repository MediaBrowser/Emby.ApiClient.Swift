//
//  ImageOptions.swift
//  Emby.ApiClient
//

import Foundation

public struct ImageOptions {
    var imageType: ImageType = .Primary
    var imageIndex: Int?
    var width: Int?
    var height: Int?
    var maxWidth: Int?
    var maxHeight: Int?
    var quality: Int?
    var tag: String?
    var cropWhiteSpace: Bool?
    var enableImageEnhancers = true
    var imageFormat: ImageFormat?
    var addPlayedIndicator: Bool?
    var percentPlayed: Int?
    var unplayedCount: Int?
    var backgroundColor: String?
}