//
//  IllegalArgumentError.swift
//  Emby.ApiClient
//

import Foundation

public enum IllegalArgumentError: Error {
    case EmptyString(argumentName: String)
}
