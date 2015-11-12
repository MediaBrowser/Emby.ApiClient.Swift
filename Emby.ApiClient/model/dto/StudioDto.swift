//
//  StudioDto.swift
//  Emby.ApiClient
//

import Foundation

public struct StudioDto {
    let name: String
    let id: String
    let primaryImageTag: String?
    var hasPrimaryImage: Bool {
        get {
            return primaryImageTag != nil
        }
    }
}