//
//  VolleyError.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 12/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package com.android.volley;
/**
* Exception style class encapsulating Volley errors
*/
//@SuppressWarnings("serial")
public class VolleyError { //extends Exception {
//    public final NetworkResponse networkResponse;
//    public VolleyError() {
//        networkResponse = null;
//    }
//    public VolleyError(NetworkResponse response) {
//        networkResponse = response;
//    }
    
    var reason: String?
    
    public init(exceptionMessage: String) {
//        super(exceptionMessage);
//        networkResponse = nil
        
        reason = exceptionMessage
        
    }
//    public VolleyError(String exceptionMessage, Throwable reason) {
//        super(exceptionMessage, reason);
//        networkResponse = null;
//    }

    var cause: NSError?
    
    public init(cause: NSError?) {
//        super(cause);
//        networkResponse = null;
        self.cause = cause
        
        print("Error happened \(cause)")
    }
}