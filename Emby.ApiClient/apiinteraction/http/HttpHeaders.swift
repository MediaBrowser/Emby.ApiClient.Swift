//
//  HttpHeaders.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package mediabrowser.apiinteraction.http;

public class HttpHeaders //extends java.util.HashMap<String,String>
{
    var data: [String: String] = [:]
    
    public func put(name: String, value: String)
    {
        data[name] = value
    }
    
//    /**
//    Gets or sets the authorization scheme.
//    <value>The authorization scheme.</value>
//    */
    private var privateAuthorizationScheme: String?
    public final func getAuthorizationScheme() -> String?
    {
        return privateAuthorizationScheme;
    }
    public final func setAuthorizationScheme(value: String?)
    {
        privateAuthorizationScheme = value;
    }
//    /**
//    Gets or sets the authorization parameter.
//    <value>The authorization parameter.</value>
//    */
    private var privateAuthorizationParameter: String?
    public final func getAuthorizationParameter() -> String?
    {
        return privateAuthorizationParameter;
    }
    public final func setAuthorizationParameter(value: String?)
    {
        privateAuthorizationParameter = value;
    }

    public final func setAccessToken(token: String?) {
        if let accessToken = token {
            self.put("X-MediaBrowser-Token", value: accessToken)
        } else {
            remove("X-MediaBrowser-Token")
        }
    }

    public final func remove(name: String) {
        self.data[name] = nil
    }
}