//
//  VolleyResponseListener.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

//package mediabrowser.apiinteraction.android;
//
//import com.android.volley.Response;
//import mediabrowser.model.logging.ILogger;

public class VolleyResponseListener<T> /*implements Response.Listener<T>*/ {
    
    private let outerResponse: Emby_ApiClient.Response<T>
    private let logger: ILogger
    private let url: String
    
    public init(outerResponse: Emby_ApiClient.Response<T>, logger: ILogger, url: String) {
        self.outerResponse = outerResponse;
        self.logger = logger;
        self.url = url;
    }
    
//    @Override
//    public void onResponse(T s) {
//        
//        logger.Info("Response received from: %s", url);
//        
//        outerResponse.onResponse(s);
//    }
    
}