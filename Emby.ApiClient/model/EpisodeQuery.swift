//
//  EpisodeQuery.swift
//  EmbyApiClient
//

import Foundation

public struct EpisodeQuery {
    var userId: String?
    var seasonId: String?
    var seriesId: String?
    var isMissing: Bool?
    var isVirtualUnaired: Bool?
    var seasonNumber: Int?
    var fields: [ItemFields]?
    var startIndex: Int?
    var limit: Int?
    var startItemId: String?
    var adjacentTo: String?
}
