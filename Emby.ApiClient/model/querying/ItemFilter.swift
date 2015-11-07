//
//  ItemFilter.swift
//  Emby.ApiClient
//

import Foundation

public enum ItemFilter: Int {
    case IsFolder = 1
    case IsNotFolder
    case IsUnplayed
    case IsPlayed
    case IsFavorite
    case IsRecentlyAdded
    case IsResumable
    case Likes
    case Dislikes
    case IsFavoriteOrLikes
}