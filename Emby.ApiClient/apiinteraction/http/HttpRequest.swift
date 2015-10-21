//
//  HttpRequest.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

//package mediabrowser.apiinteraction.http;
//
//import mediabrowser.apiinteraction.QueryStringDictionary;

public class HttpRequest
{
    private var Method: String?
    public final func getMethod() -> String?
    {
        return Method;
    }
    public final func setMethod(value: String)
    {
        Method = value;
    }
//    private String RequestContent;
//    public final String getRequestContent()
//    {
//    return RequestContent;
//    }
//    public final void setRequestContent(String value)
//    {
//    RequestContent = value;
//    }
    private var RequestContentType: String?
    public final func getRequestContentType() -> String?
    {
    return RequestContentType;
    }
    public final func setRequestContentType(value: String)
    {
    RequestContentType = value;
    }
    private var RequestHeaders: HttpHeaders?
    public final func getRequestHeaders() -> HttpHeaders?
    {
        return RequestHeaders
    }
    public final func setRequestHeaders(value: HttpHeaders)
    {
        RequestHeaders = value;
    }
    private var Url: String?
    public final func getUrl() -> String?
    {
        return Url;
    }
    public final func setUrl(value: String)
    {
        Url = value;
    }
    
//    private int Timeout;
//    public final int getTimeout()
//    {
//    return Timeout;
//    }
//    public final void setTimeout(int value)
//    {
//    Timeout = value;
//    }
//    
    private var postData: QueryStringDictionary?
    public final func getPostData() -> QueryStringDictionary?
    {
        return postData;
    }
    public final func setPostData(value: QueryStringDictionary)
    {
        postData = value;
    }

    public init()
    {
        setRequestHeaders(HttpHeaders());
//        setTimeout(30000);
    }
}
