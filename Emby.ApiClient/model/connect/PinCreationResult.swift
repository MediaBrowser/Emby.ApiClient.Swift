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
    public required init(jSON: JSON_Object) {
        super.init(jSON: jSON)
        
//{"Id":null,"Pin":"09751","DeviceId":"203AD7FD-333B-4926-A2EF-414748DF8FCF","IsExpired":false,"IsConfirmed":false,"AccessToken":null}        
        
//{"Id":"465875","Pin":"09751","DeviceId":"203AD7FD-333B-4926-A2EF-414748DF8FCF","IsExpired":false,"IsConfirmed":true,"AccessToken":"dd8a4f34dc2ed55765c21b217134f509"}
        
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