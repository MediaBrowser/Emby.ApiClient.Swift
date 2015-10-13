//
//  ILogger.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package mediabrowser.model.logging;

/**
Interface ILogger
*/
public protocol ILogger
{
    /**
    Infoes the specified message.
    @param message The message.
    @param paramList The param list.
    */
//    func Info(message: String, _: AnyObject...)
    func Info(message: String)
    
//    /**
//    Errors the specified message.
//    @param message The message.
//    @param paramList The param list.
//    */
//    void Error(String message, Object... paramList);
//    
//    /**
//    Warns the specified message.
//    @param message The message.
//    @param paramList The param list.
//    */
//    void Warn(String message, Object... paramList);
    
    /**
    Debugs the specified message.
    @param message The message.
    @param paramList The param list.
    */
//    func Debug(message: String, _: AnyObject...)
    func Debug(message: String)
    
//    /**
//    Fatals the specified message.
//    @param message The message.
//    @param paramList The param list.
//    */
//    void Fatal(String message, Object... paramList);
//    
//    /**
//    Fatals the exception.
//    @param message The message.
//    @param exception The exception.
//    @param paramList The param list.
//    */
//    void FatalException(String message, Exception exception, Object... paramList);
//    
//    /**
//    Logs the exception.
//    @param message The message.
//    @param exception The exception.
//    @param paramList The param list.
//    */
//    void ErrorException(String message, Exception exception, Object... paramList);
}