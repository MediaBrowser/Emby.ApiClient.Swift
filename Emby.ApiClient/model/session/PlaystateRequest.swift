//
//  PlaystateRequest.swift
//  EmbyApiClient
//

import Foundation

public struct PlaystateRequest {
    var command = PlaystateCommand.Stop
    let seekPositionTicks: Int
    let controllingUserId: String
}