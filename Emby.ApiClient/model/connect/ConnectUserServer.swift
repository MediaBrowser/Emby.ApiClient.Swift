//
//  ConnectUserServer.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 08/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package mediabrowser.model.connect;

public class ConnectUserServer: GenericResult
{
    public required init(jSON: JSON) {
        super.init(jSON: jSON)
        
//        if let user = jSON["User"] as? JSON {
//            self.User = ConnectUser(jSON: user)
//        }
//        
//        if let accessToken = jSON["AccessToken"] as? String {
//            self.AccessToken = accessToken
//        }
    }
    
    private var Id: String?
    public final func getId() -> String?
    {
        return Id;
    }
    public final func setId(value: String)
    {
        Id = value;
    }
    private var Url: String?
    public final func getUrl() -> String?
    {
        return Url;
    }
    public final func setUrl(value: String)
    {
        Url = value;
    }
    private var Name: String?
    public final func getName() -> String?
    {
        return Name;
    }
    public final func setName(value: String)
    {
        Name = value;
    }
    private var AccessKey: String?
    public final func getAccessKey() -> String?
    {
        return AccessKey;
    }
    public final func setAccessKey(value: String)
    {
        AccessKey = value;
    }
    private var SystemId: String?
    public final func getSystemId() -> String?
    {
        return SystemId;
    }
    public final func setSystemId(value: String)
    {
        SystemId = value;
    }
    private var LocalAddress: String?
    public final func getLocalAddress() -> String?
    {
        return LocalAddress;
    }
    public final func setLocalAddress(value: String)
    {
        LocalAddress = value;
    }
    private var UserType: String?
    public final func getUserType() -> String?
    {
        return UserType;
    }
    public final func setUserType(value: String)
    {
        UserType = value;
    }
}