//
//  ProgressProtocol.swift
//  Emby.ApiClient
//

import Foundation

public protocol ProgressProtocol<T> {
    func report(T progress) -> Void
    func reportComplete() -> Void
    func reportCancelled() -> Void
    func reportError(error: ErrorType) -> Void
}