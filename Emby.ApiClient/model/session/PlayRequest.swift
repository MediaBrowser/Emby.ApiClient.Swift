//
//  PlayRequest.swift
//  EmbyApiClient
//

import Foundation

public struct PlayRequest {
    let itemIds: [String]
    let startPositionTicks: Int
    var playCommand = PlayCommand.PlayNow
    let controllingUserId: String
}