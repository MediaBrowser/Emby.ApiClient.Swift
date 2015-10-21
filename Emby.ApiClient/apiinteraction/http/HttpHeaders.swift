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
    public final func setAuthorizationScheme(value: String)
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
    public final func setAuthorizationParameter(value: String)
    {
        privateAuthorizationParameter = value;
    }

//    /**
//    Sets the access token.
//    @param token The token.
//    */
//    public final void SetAccessToken(String token)
//    {
//        if (tangible.DotNetToJavaStringHelper.isNullOrEmpty(token))
//        {
//            this.remove("X-MediaBrowser-Token");
//        }
//        else
//        {
//            this.put("X-MediaBrowser-Token", token);
//        }
//    }
}