//
//  UpcomingEpisodesQuery.swift
//  EmbyApiClient
//

import Foundation

public struct UpcomingEpisodesQuery {
    var userId: String?
    var parentId: String?
    var startIndex: Int?
    var limit: Int?
    var fields: [ItemFields]?
    var enableImages: Bool?
    var imageTypeLimit: Int?
    var enableImageTypes: [ImageType]?
}

