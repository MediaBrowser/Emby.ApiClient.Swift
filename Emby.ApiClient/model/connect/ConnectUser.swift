//
//  ConnectUser.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 08/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package mediabrowser.model.connect;

public class ConnectUser: GenericResult
{
    public required init(jSON: JSON_Object) {
        super.init(jSON: jSON)
    
//{"Id":"79718","Name":"vedrano","DisplayName":"vedrano","Email":"vedran.ozir@gmail.com","IsActive":"true","ImageUrl":"http:\/\/www.gravatar.com\/avatar\/1231d710dfba30dd91868a20f737e0db?s=200&d=http%3A%2F%2Fmb3admin.com%2Fimages%2Fuser.png"}
        
        if let Id = jSON["Id"] as? String {
            self.Id = Id
        }
        
        if let Name = jSON["Name"] as? String {
            self.Name = Name
        }
        
        if let Email = jSON["Email"] as? String {
            self.Email = Email
        }
        
        if let IsActive = jSON["IsActive"] as? NSString {
            self.IsActive = IsActive.boolValue
        }
        
        if let ImageUrl = jSON["ImageUrl"] as? String {
            self.ImageUrl = ImageUrl
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
    private var IsActive: Bool?
    public final func getIsActive() -> Bool?
    {
        return IsActive;
    }
    public final func setIsActive(value:Bool)
    {
        IsActive = value;
    }
    private var ImageUrl: String?
    public final func getImageUrl() -> String?
    {
        return ImageUrl;
    }
    public final func setImageUrl(value: String)
    {
        ImageUrl = value;
    }
}