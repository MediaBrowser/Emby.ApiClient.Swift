//
//  RegistrationInfo.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 09/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package mediabrowser.model.registration;

public class RegistrationInfo: GenericResult
{
    public required init(jSON: JSON_Object) {
        super.init(jSON: jSON)
 
        //{"Name":"TV","ExpirationDate":"2015-11-15","IsTrial":true,"IsRegistered":false}
        
        if let Name = jSON["Name"] as? String {
            self.Name = Name
        }
        
        if let ExpirationDateAsString = jSON["ExpirationDate"] as? String {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            if let ExpirationDate = formatter.dateFromString(ExpirationDateAsString) {
                self.ExpirationDate = ExpirationDate
            }
        }
        
        if let IsTrial = jSON["IsTrial"] as? Bool {
            self.IsTrial = IsTrial
        }
        if let IsRegistered = jSON["IsRegistered"] as? Bool {
            self.IsRegistered = IsRegistered
        }
    }
    /**
    Gets or sets the name.
    
    <value>The name.</value>
    */
    private var Name: String?
    public func getName() -> String?
    {
    return Name;
    }
    public func setName(value: String)
    {
    Name = value;
    }
    /**
    Gets or sets the expiration date.
    
    <value>The expiration date.</value>
    */
    private var ExpirationDate: NSDate = NSDate(); // should be a date with initial value of 0?
    public final func getExpirationDate() -> NSDate?
    {
    return ExpirationDate;
    }
    public func setExpirationDate(value: NSDate)
    {
    ExpirationDate = value;
    }
    /**
    Gets or sets a value indicating whether this instance is trial.
    
    <value><c>true</c> if this instance is trial; otherwise, <c>false</c>.</value>
    */
    private var IsTrial: Bool?
    public final func getIsTrial() -> Bool?
    {
    return IsTrial;
    }
    public func setIsTrial(value: Bool)
    {
    IsTrial = value;
    }
    /**
    Gets or sets a value indicating whether this instance is registered.
    
    <value><c>true</c> if this instance is registered; otherwise, <c>false</c>.</value>
    */
    private var IsRegistered: Bool?
    public final func getIsRegistered() -> Bool?
    {
    return IsRegistered;
    }
    public func setIsRegistered(value: Bool)
    {
    IsRegistered = value;
    }
}