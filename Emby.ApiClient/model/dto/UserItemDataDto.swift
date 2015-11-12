//
//  UserItemDataDto.swift
//  Emby.ApiClient
//

import Foundation

public struct UserItemDataDto {
    var rating: Double?
    var playedPercentage: Double?
    var unplayedItemCount: Int?
    var playbackPositionTicks: Int?
    var playCount: Int?
    var isFavorite: Bool?
    var likes: Bool?
    var lastPlayedDate: NSDate?
    var played: Bool?
    var key: String?
    var itemId: String?
}