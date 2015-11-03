//
//  ConnectUserQuery.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 08/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package mediabrowser.model.connect;

public class ConnectUserQuery: GenericResult
{
    public required init(jSON: JSON_Object) {
        super.init(jSON: jSON)
        
        if let Id = jSON["Id"] as? String {
            self.Id = Id
        }
        
        if let Name = jSON["Name"] as? String {
            self.Name = Name
        }
        
        if let Email = jSON["Email"] as? String {
            self.Email = Email
        }
        
        if let NameOrEmail = jSON["NameOrEmail"] as? String {
            self.NameOrEmail = NameOrEmail
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
    private var Name: String?
    public final func getName() -> String?
    {
        return Name;
    }
    public final func setName(value: String)
    {
        Name = value;
    }
    private var Email: String?
    public final func getEmail() -> String?
    {
        return Email;
    }
    public final func setEmail(value: String)
    {
        Email = value;
    }
    private var NameOrEmail: String?
    public final func getNameOrEmail() -> String?
    {
        return NameOrEmail;
    }
    public final func setNameOrEmail(value: String)
    {
        NameOrEmail = value;
    }
}