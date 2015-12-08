//
//  HttpHeaderInfo.swift
//  Emby.ApiClient
//

import Foundation

public struct HttpHeaderInfo {
    let name: String
    let value: String
    let match = HeaderMatchType.Equals
}