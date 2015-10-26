//
//  PinCreationResult.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 08/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package mediabrowser.model.connect;

public class PinCreationResult: GenericResult
{
    public required init(jSON: JSON) {
        super.init(jSON: jSON)
        
        if let DeviceId = jSON["DeviceId"] as? String {
            self.DeviceId = DeviceId
        }
        
        if let Pin = jSON["Pin"] as? String {
            self.Pin = Pin
        }
        
        if let IsExpired = jSON["IsExpired"] as? Bool {
            self.IsExpired = IsExpired
        }
        
        if let IsConfirmed = jSON["IsConfirmed"] as? Bool {
            self.IsConfirmed = IsConfirmed
        }
    }
    
    private var Pin: String?
    public final func getPin() -> String?
    {
    return Pin;
    }
    public final func setPin(value: String)
    {
    Pin = value;
    }
    private var DeviceId: String?
    public final func getDeviceId() -> String?
    {
    return DeviceId;
    }
    public final func setDeviceId(value: String)
    {
    DeviceId = value;
    }
    private var IsConfirmed: Bool?
    public final func getIsConfirmed() -> Bool?
    {
        return IsConfirmed;
    }
    public final func setIsConfirmed(value: Bool)
    {
        IsConfirmed = value;
    }
    private var IsExpired: Bool?
    public final func getIsExpired() -> Bool?
    {
        return IsExpired;
    }
    public final func setIsExpired(value: Bool)
    {
        IsExpired = value;
    }
}