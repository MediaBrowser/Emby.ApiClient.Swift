//
//  HttpHeaders.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

public class HttpHeaders
{
    var data: [String: String] = [:]
    
    var authorizationScheme: String?
    var authorizationParameter: String?

    public final func setAccessToken(token: String?) {
        if let accessToken = token {
            self["X-MediaBrowser-Token"] = accessToken
        } else {
            self["X-MediaBrowser-Token"] = nil
        }
    }
    
    subscript(index: String) -> String? {
        get {
            return data[index]
        }
        set(newValue) {
            data[index] = newValue
        }
    }
}