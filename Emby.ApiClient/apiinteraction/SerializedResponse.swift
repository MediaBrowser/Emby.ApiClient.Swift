//
//  SerializedResponse.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

//package mediabrowser.apiinteraction;
//
//import mediabrowser.apiinteraction.Response;
//import mediabrowser.model.logging.ILogger;
//import mediabrowser.model.serialization.IJsonSerializer;

public class SerializedResponse<T>: Emby_ApiClient.Response<String> {
    
    private let jsonSerializer: IJsonSerializer
    private let type: AnyClass
    /*protected*/ let innerResponse: Emby_ApiClient.Response<T>
    private let url: String? = nil
//    private ILogger logger;
    
    public init(innerResponse: Emby_ApiClient.Response<T>, jsonSerializer: IJsonSerializer, type: AnyClass) {
//        super(innerResponse);
        self.jsonSerializer = jsonSerializer;
        self.type = type;
        self.innerResponse = innerResponse;
    }
    
//    public SerializedResponse(Emby_ApiClient.Response<T> innerResponse, IJsonSerializer jsonSerializer, String url, ILogger logger, Class type) {
//        super(innerResponse);
//        self.jsonSerializer = jsonSerializer;
//        self.type = type;
//        self.innerResponse = innerResponse;
//        self.url = url;
//        self.logger = logger;
//    }
//    
//    
//    @Override
//    public void onResponse(String result) {
//        
//        if (url != null){
//            logger.Debug("Received response from %s", url);
//        }
//        
//        T obj = jsonSerializer.DeserializeFromString(result, type);
//        
//        onSerializedResponse(obj);
//    }
//    
//    protected void onSerializedResponse(T obj){
//        innerResponse.onResponse(obj);
//    }
    
}