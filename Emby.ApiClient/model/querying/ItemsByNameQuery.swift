//
//  ItemsByNameQuery.swift
//  Emby.ApiClient
//

import Foundation

public struct ItemsByNameQuery {
    var userId: String?
    var startIndex: Int?
    var limit: Int?
    var recursive: Bool? = true
    var sortOrder: SortOrder?
    var parentId: String?
    var fields: [ItemFields]?
    var filters: [ItemFilter]?
    var excludeItemTypes: [String]?
    var includeItemTypes: [String]?
    var mediaTypes: [String]?
    var sortBy: [String]?
    var imageTypes: [ImageType]?
    var nameStartsWithOrGreater: String?
    var nameStartsWith: String?
    var nameLessThan: String?
    var isPlayed: Bool?
    var enableImages: Bool?
    var imageTypeLimit: Int?
    var enableImageTypes: [ImageType]?
}