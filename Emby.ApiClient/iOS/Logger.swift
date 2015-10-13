//
//  Logger.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 12/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

public class Logger: ILogger {
    
    public init() {
    }
    
    public func Info(message: String) {

        print(message)
    }

    public func Debug(message: String) {
        
        print(message)
    }
}