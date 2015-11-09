//
//  SimilarItemsQuery.swift
//  Emby.ApiClient
//

import Foundation

public struct SimilarItemsQuery {
    var userId: String?
    var id: String?
    var limit: Int?
    var fields: [ItemFields]?
}