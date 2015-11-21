//
//  IllegalArgumentError.swift
//  Emby.ApiClient
//

import Foundation

public enum IllegalArgumentError: ErrorType {
    case EmptyString(argumentName: String)
}