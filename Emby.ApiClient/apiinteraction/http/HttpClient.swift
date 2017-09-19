//
//  HttpClient.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
import Alamofire

public class HttpClient : IAsyncHttpClient {
    
    private let logger: ILogger
    private let context: Context
    
    public init(logger: ILogger, context: Context) {
        self.logger = logger;
        self.context = context;
    }
    
    public func sendRequest<T : JSONSerializable>(request: HttpRequest, success: @escaping (T) -> Void, failure: @escaping (EmbyError) -> Void) {
        
        Alamofire.request(request)
            .validate { request, response, data in
                // custom evalution clousre now includes data (allows you to parse data to dig out error messeages
                return .success
            }
            .responseJSON { response in
                
                if case .success(let json) = response.result {
                    if  let jsonObject = json as? JSON_Object {
                        
                        if let object = T(jSON: jsonObject) {
                            success(object)
                        }
                        else {
                            failure(EmbyError.JsonDeserializationError)
                        }
                    }
                    else {
                        failure(EmbyError.JsonDeserializationError)
                    }
                }
                else if case .failure(let error) = response.result {
                    failure(EmbyError.NetworkRequestError(error.localizedDescription))
                }
        }
    }
    
    public func sendCollectionRequest<T : JSONSerializable>(request: HttpRequest, success: @escaping ([T]) -> Void, failure: @escaping (EmbyError) -> Void) {
        
        Alamofire.request(request)
            .validate { request, response, data in
                // custom evalution clousre now includes data (allows you to parse data to dig out error messeages
                return .success
            }
            .responseJSON { response in
                
                if case .success(let json) = response.result {
                    if let jsonArray = json as? JSON_Array {
                        
                        var results: [T] = []
                        
                        for object in jsonArray {
                            if let jsonObject = object as? JSON_Object, let object = T(jSON: jsonObject) {
                                results.append(object)
                            }
                        }
                        
                        success(results)
                    }
                    else {
                        failure(EmbyError.JsonDeserializationError)
                    }
                }
                else if case .failure(let error) = response.result {
                    failure(EmbyError.NetworkRequestError(error.localizedDescription))
                }
        }
    }
}

public enum EmbyError: Error {
    
    case JsonDeserializationError
    case NetworkRequestError(String)
}
