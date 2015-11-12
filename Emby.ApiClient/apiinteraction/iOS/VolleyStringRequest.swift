//
//  VolleyStringRequest.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

//package mediabrowser.apiinteraction.android;
//
//import com.android.volley.AuthFailureError;
//import com.android.volley.NetworkResponse;
//import com.android.volley.Response;
//import com.android.volley.toolbox.StringRequest;
//import mediabrowser.apiinteraction.http.HttpHeaders;
//import mediabrowser.apiinteraction.http.HttpRequest;
//import mediabrowser.model.extensions.StringHelper;
//
//import java.util.HashMap;
//import java.util.Map;

public class VolleyStringRequest<T>: StringRequest<T> {
    
//    private let request: HttpRequest
    let request: HttpRequest
    
    /*public*/ init( method: String, url: String, listener: Response_Listener<T>/*<String>*/, errorListener: Response_ErrorListener, request: HttpRequest) {
        self.request = request;
        super.init(method: method, url: url, listener: listener, errorListener: errorListener);
    }
    
//    public VolleyStringRequest(String url, Response.Listener<String> listener, Response.ErrorListener errorListener, HttpRequest request) {
//        super(url, listener, errorListener);
//        this.request = request;
//    }
//    
//    @Override
//    public Map<String, String> getHeaders() throws AuthFailureError {
    public override func getHeaders() throws -> [String: String] {
        var headers = [String: String]();
        AddHeaders(&headers, request: request);
        return headers;
    }

//    @Override
//    public Map<String, String> getParams() throws AuthFailureError {
//        
//        if (request.getPostData() == null){
//            super.getParams();
//        }
//        
//        Map<String, String> data = new HashMap<String,String>();
//        AddData(data, request);
//        return data;
//    }
//    
//    @Override
//    public String getBodyContentType() {
//        
//        if (!tangible.DotNetToJavaStringHelper.isNullOrEmpty(request.getRequestContentType()))
//        {
//            return request.getRequestContentType();
//        }
//        
//        return super.getBodyContentType();
//    }
//    
//    @Override
//    /**
//    * Returns the raw POST or PUT body to be sent.
//    * @throws AuthFailureError in the event of auth failure
//    */
//    public byte[] getBody() throws AuthFailureError {
//        
//        String postContent = request.getRequestContent();
//        
//        if (postContent == null){
//            return super.getBody();
//        }
//        
//        return postContent.getBytes();
//    }
//    
//    @Override
//    protected com.android.volley.Response<String> parseNetworkResponse(NetworkResponse response) {
//        
//        String contentType = response.headers.get("Content-Type");
//        
//        // This is a hack to make volley decode in UTF-8
//        if (StringHelper.EqualsIgnoreCase(contentType, "application/json")) {
//            response.headers.put("Content-Type", contentType + "; charset=UTF-8");
//        }
//        else if (StringHelper.EqualsIgnoreCase(contentType, "text/plain")) {
//            response.headers.put("Content-Type", contentType + "; charset=UTF-8");
//        }
//        else if (StringHelper.EqualsIgnoreCase(contentType, "text/vtt")) {
//            response.headers.put("Content-Type", contentType + "; charset=UTF-8");
//        }
//        
//        return super.parseNetworkResponse(response);
//    }
    
//    private void AddHeaders(Map<String, String> headers, HttpRequest request)
    private func AddHeaders(inout headers: [String: String], request: HttpRequest)
    {
        let requestHeaders = request.getRequestHeaders();
        
        if let data = requestHeaders?.data {
            
            for (index, value) in data {
                headers[index] = value
            }
        }
        
        if let RequestContentType = request.getRequestContentType()
        {
            headers["Content-Type"] = RequestContentType
        }
        
        if let
            parameter = requestHeaders?.getAuthorizationParameter(),
            authorizationScheme = requestHeaders?.getAuthorizationScheme()
        {
            let value = authorizationScheme + " " + parameter;
            
            headers["X-Emby-Authorization"] = value
        }
    }
    
//    private void AddData(Map<String, String> postParams, HttpRequest request)
//    {
//        if (request.getPostData() == null){
//            return;
//        }
//        
//        for (String key : request.getPostData().keySet()){
//            postParams.put(key, request.getPostData().get(key));
//        }
//    }
}