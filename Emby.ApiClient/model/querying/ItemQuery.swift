//
//  ItemQuery.swift
//  Emby.ApiClient
//

import Foundation

public struct ItemQuery {
    var userId: String?
    var parentId: String?
    var startIndex: Int?
    var limit: Int?
    var sortBy: [String]?
    var artistIds: [String]?
    var sortOrder: SortOrder?
    var filters: [ItemFilter]?
    var fields: [ItemFields]?
    var mediaTypes: [String]?
    var is3d: Bool?
    var videoTypes: [VideoType]?
    var recursive: Bool?
    var genres: [String]?
    var studioIds: [String]?
    var excludeItemTypes: [String]?
    var includeItemTypes: [String]?
    var years: [Int]?
    var personIds: [String]?
    var personTypes: [String]?
    var searchTerm: String?
    var imageTypes: [ImageType]?
    var airDays: [String]?
    var seriesStatus: [SeriesStatus]?
    var ids: [String]?
    var minOfficialRating: String?
    var maxOfficialRating: String?
    var minIndexNumber: Int?
    var hasParentRating: Bool?
    var isHd: Bool?
    var parentIndexNumber: Int?
    var minPlayers: Int?
    var maxPlayers: Int?
    var nameStartsWithOrGreater: String?
    var nameStartsWith: String?
    var nameLessThan: String?
    var albumArtistStartsWithOrGreater: String?
    var includeIndexContainers: Bool?
    var locationTypes: [LocationType]?
    var isMissing: Bool?
    var isUnaired: Bool?
    var isVirtualUnaired: Bool?
    var isInBoxSet: Bool?
    var collapseBoxSetItem: Bool?
    var isPlayed: Bool?
    var excludeLocationTypes: [LocationType]?
    var minCommunityRating: Double?
    var minCriticRating: Double?
    var airedDuringSeasion: Int?
    var minPremiereDate: NSDate?
    var maxPremiereDate: NSDate?
    var enableImages: Bool?
    var imageTypeLimit: Int?
    var enableImageTypes: [ImageType]?
    var artists: [String]?
    var studios: [String]?
    var person: String?
}