//
//  HttpRequest.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

import Alamofire

public struct HttpRequest : URLRequestConvertible
{    
    let method: Alamofire.Method
    let url: String
    
    let postData: QueryStringDictionary?
    
    var requestContent: String?
    var requestContentType: String?
    
    var headers: HttpHeaders = HttpHeaders()
    
    init(url: String, method: Alamofire.Method, postData: QueryStringDictionary? = nil) {
        self.url = url
        self.method = method
        self.postData = postData
    }
    
    public var URLRequest: NSMutableURLRequest {
        let url = NSURL(string: self.url)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method.rawValue
        
        
        let encoding = postData != nil ? Alamofire.ParameterEncoding.JSON : Alamofire.ParameterEncoding.URL
        
        let (encodedURL, error) = encoding.encode(request, parameters: postData?.data)
        if let error = error {
            print(error)
        }
        
        if headers.data.count > 0 {
            for (key, value) in headers.data {
                encodedURL.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return encodedURL
    }
    
    mutating func addHeaders(newHeaders: HttpHeaders) {
        
        if let contentType = requestContentType {
            newHeaders["Content-Type"] = contentType
        } else {
            newHeaders["Content-Type"] = "application/json"
        }
        
        if let authParameter = newHeaders.authorizationParameter, authScheme = newHeaders.authorizationScheme {
            let value = authScheme + " " + authParameter
            newHeaders["X-Emby-Authorization"] = value
        }
        
        headers = newHeaders
    }
}

