//
//  EpisodeQuery.swift
//  EmbyApiClient
//

import Foundation

public struct SeasonQuery {
    var userId: String?
    var seriesId: String?
    var isMissing: Bool?
    var isVirtualUnaired: Bool?
    var fields: [ItemFields]?
    var isSpecialSeason: Bool?
}



