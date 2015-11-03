//
//  ConnectAuthenticationResult.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package mediabrowser.model.connect;

public class GenericResult: JSONSerializable
{
    public required init(jSON: JSON_Object) {
    }
}

public class ConnectAuthenticationResult: GenericResult
{
    public required init(jSON: JSON_Object) {
        super.init(jSON: jSON)
        
        if let user = jSON["User"] as? JSON_Object {
            self.User = ConnectUser(jSON: user)
        }
        
        if let accessToken = jSON["AccessToken"] as? String {
            self.AccessToken = accessToken
        }
    }
    /**
    Gets or sets the user.
    
    <value>The user.</value>
    */
    private var User: ConnectUser?
    public func getUser() -> ConnectUser?
    {
        return User
    }
    public final func setUser(value: ConnectUser)
    {
        User = value
    }
    /**
    Gets or sets the access token.
    
    <value>The access token.</value>
    */
    private var AccessToken: String?
    public final func getAccessToken() -> String?
    {
        return AccessToken
    }
    public final func setAccessToken(value: String)
    {
        AccessToken = value
    }
}