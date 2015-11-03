//
//  ConnectUserServer.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 08/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package mediabrowser.model.connect;

public class ConnectUserServers: GenericResult {

    var servers = [ConnectUserServer]()

    public required init(jSON: JSON_Object) {
        super.init(jSON: jSON)
        
        //[{"Id":"776fb00e3fae53fc00ad8f44090eeacb","Url":"http:\/\/109.227.62.202:8096","Name":"Vedrans-Mini.lan","SystemId":"acd3038ee3c44fd2b475fc1cd2aa1f76","AccessKey":"3c3c65d756ef4bfa9a2a9c2c8d0fd147","LocalAddress":"http:\/\/192.168.1.66:8096","UserType":"Linked","SupporterKey":""}]
        
        if let jSON_Array = jSON.jSON_Array {
            
            for server in jSON_Array {
                
                if let serverDict = server as? JSON_Dictionary {
                    
                    let server = ConnectUserServer(jSON: JSON_Object(jSON_Dictionary: serverDict ))
                    
                    servers.append(server)
                }
                
            }
        }
        
    }
}

public class ConnectUserServer: GenericResult
{
    public required init(jSON: JSON_Object) {
        super.init(jSON: jSON)
        
        if let Id = jSON["Id"] as? String {
            self.Id = Id
        }
        
        if let Url = jSON["Url"] as? String {
            self.Url = Url
        }
        
        if let Name = jSON["Name"] as? String {
            self.Name = Name
        }
        
        if let SystemId = jSON["SystemId"] as? String {
            self.SystemId = SystemId
        }
        
        if let AccessKey = jSON["AccessKey"] as? String {
            self.AccessKey = AccessKey
        }
        
        if let LocalAddress = jSON["LocalAddress"] as? String {
            self.LocalAddress = LocalAddress
        }
        
        if let UserType = jSON["UserType"] as? String {
            self.UserType = UserType
        }
        
        if let SupporterKey = jSON["SupporterKey"] as? String {
            self.SupporterKey = SupporterKey
        }
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
    
    private var SupporterKey: String?
}