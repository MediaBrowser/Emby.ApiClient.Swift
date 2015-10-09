//
//  ConnectUserQuery.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 08/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package mediabrowser.model.connect;

public class ConnectUserQuery
{
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