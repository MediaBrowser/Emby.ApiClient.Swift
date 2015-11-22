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

//public class VolleyResponseListener<T> implements Response.Listener<T> {
public class VolleyResponseListener<T>: Response_Listener<T> {
    
    private let outerResponse: EmbyApiClient.Response<T>
    private let logger: ILogger
    private let url: String
    
    public init(outerResponse: EmbyApiClient.Response<T>, logger: ILogger, url: String) {
        self.outerResponse = outerResponse;
        self.logger = logger;
        self.url = url;
    }
    
//    @Override
//    public func onResponse(s: T) {
//    public func onResponse(s: Any) {
    public override func onResponse(s: Any) throws -> T? {
//    let a = outerResponse as? Emby.Response
        logger.Info("Response received from: '" + url + "'");
//        logger.Debug("Response received from: " + url + " is " + s.description);
        
        return try outerResponse.onResponse(s);
    }
    

    
//    private mediabrowser.apiinteraction.Response<T> outerResponse;
//    private ILogger logger;
//    private String url;
//    
//    public VolleyResponseListener(mediabrowser.apiinteraction.Response<T> outerResponse, ILogger logger, String url) {
//        this.outerResponse = outerResponse;
//        this.logger = logger;
//        this.url = url;
//    }
//    
//    @Override
//    public void onResponse(T s) {
//        
//        logger.Info("Response received from: %s", url);
//        
//        outerResponse.onResponse(s);
//    }
    
}