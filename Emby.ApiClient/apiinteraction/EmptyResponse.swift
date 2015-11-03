//
//  EmptyResponse.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 13/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package mediabrowser.apiinteraction;

public class EmptyResponse: GenericResult
{
    private var innerResponse: IResponse?
    
//    init(innerResponse: IResponse? = nil){
//        
//        self.innerResponse = innerResponse;
//        super.init(jSON: JSON_Object())
//    }

    public required init(jSON: JSON_Object) {
        super.init(jSON: jSON)
    }

//    public EmptyResponse(){
//        
//    }
//    
//    public void onResponse()
//    {
//        triggerInnerResponse();
//    }
//    
//    protected void triggerInnerResponse(){
//        if (innerResponse != null && innerResponse instanceof EmptyResponse){
//            
//            EmptyResponse emptyResponse = (EmptyResponse)innerResponse;
//            emptyResponse.onResponse();
//        }
//    }
//    
//    @Override
    public func onError(error: NSError)
    {
        innerResponse?.onError(error)
    }
}