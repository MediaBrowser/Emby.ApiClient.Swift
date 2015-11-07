//
//  SubtitleDownloadOptions.swift
//  Emby.ApiClient
//

import Foundation

public struct SubtitleDownloadOptions {
    var itemId: String
    var mediaSourceId: String
    var streamIndex: Int
    var format: String
}