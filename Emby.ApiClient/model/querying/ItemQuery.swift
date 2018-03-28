//
//  ItemQuery.swift
//  Emby.ApiClient
//

import Foundation

public struct ItemQuery {
    public init() {}
    public var userId: String?
    public var parentId: String?
    public var startIndex: Int?
    public var limit: Int?
    public var sortBy: [String]?
    public var artistIds: [String]?
    public var sortOrder: SortOrder?
    public var filters: [ItemFilter]?
    public var fields: [ItemFields]?
    public var mediaTypes: [String]?
    public var is3d: Bool?
    public var videoTypes: [VideoType]?
    public var recursive: Bool?
    public var genres: [String]?
    public var studioIds: [String]?
    public var excludeItemTypes: [String]?
    public var includeItemTypes: [String]?
    public var years: [Int]?
    public var personIds: [String]?
    public var personTypes: [String]?
    public var searchTerm: String?
    public var imageTypes: [ImageType]?
    public var airDays: [String]?
    public var seriesStatus: [SeriesStatus]?
    public var ids: [String]?
    public var minOfficialRating: String?
    public var maxOfficialRating: String?
    public var minIndexNumber: Int?
    public var hasParentRating: Bool?
    public var isHd: Bool?
    public var parentIndexNumber: Int?
    public var minPlayers: Int?
    public var maxPlayers: Int?
    public var nameStartsWithOrGreater: String?
    public var nameStartsWith: String?
    public var nameLessThan: String?
    public var albumArtistStartsWithOrGreater: String?
    public var includeIndexContainers: Bool?
    public var locationTypes: [LocationType]?
    public var isMissing: Bool?
    public var isUnaired: Bool?
    public var isVirtualUnaired: Bool?
    public var isInBoxSet: Bool?
    public var collapseBoxSetItem: Bool?
    public var isPlayed: Bool?
    public var excludeLocationTypes: [LocationType]?
    public var minCommunityRating: Double?
    public var minCriticRating: Double?
    public var airedDuringSeasion: Int?
    public var minPremiereDate: NSDate?
    public var maxPremiereDate: NSDate?
    public var enableImages: Bool?
    public var enableTotalRecordCount: Bool?
    public var imageTypeLimit: Int?
    public var enableImageTypes: [ImageType]?
    public var artists: [String]?
    public var studios: [String]?
    public var person: String?
}
