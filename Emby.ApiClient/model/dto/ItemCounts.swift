//
//  ItemCounts.swift
//  EmbyApiClient
//

import Foundation

public struct ItemCounts : JSONSerializable {
    var movieCount = 0
    var seriesCount = 0
    var episodeCount = 0
    var gameCount = 0
    var gameSystemCount = 0
    var trailerCount = 0
    var songCount = 0
    var albumCount = 0
    var musicVideoCount = 0
    var boxSetCount = 0
    var bookCount = 0
    var uniqueTypes = [String]()
    
    public init?(jSON: JSON_Object) {
        fatalError("init(jSON:) has not been implemented: \(jSON)")
    }
}