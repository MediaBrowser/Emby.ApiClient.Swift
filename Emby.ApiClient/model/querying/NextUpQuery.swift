//
//  NextUpQuery.swift
//  Emby.ApiClient
//

import Foundation

public struct NextUpQuery {
    var userId: String?
    var parentId: String?
    var seriesId: String?
    var startIndex: Int?
    var limit: Int?
    var fields: [ItemFields]?
    var enableImages: Bool?
    var imageTypeLimit: Int?
    var enableImageTypes: [ImageType]?
}