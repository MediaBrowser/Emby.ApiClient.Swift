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
//    private boolean IsConfirmed;
//    public final boolean getIsConfirmed()
//    {
//    return IsConfirmed;
//    }
//    public final void setIsConfirmed(boolean value)
//    {
//    IsConfirmed = value;
//    }
//    private boolean IsExpired;
//    public final boolean getIsExpired()
//    {
//    return IsExpired;
//    }
//    public final void setIsExpired(boolean value)
//    {
//    IsExpired = value;
//    }
}