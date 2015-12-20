//
//  GeneralCommand.swift
//  EmbyApiClient
//

import Foundation

public struct GeneralCommand {
    let name: String
    let controllingUserId: String
    var arguments = [String: String]()
}