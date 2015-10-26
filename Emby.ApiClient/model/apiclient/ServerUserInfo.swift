//
//  ServerUserInfo.swift
//  Emby.ApiClient
//

import Foundation

public struct ServerUserInfo: Hashable {
    let id: String
    let isSignedInOffline: Bool
    public var hashValue: Int {
        get {
            return id.hashValue
        }
    }
}

//MARK: - Equatable
public func ==(lhs: ServerUserInfo, rhs: ServerUserInfo) -> Bool {
    return lhs.id == rhs.id
}