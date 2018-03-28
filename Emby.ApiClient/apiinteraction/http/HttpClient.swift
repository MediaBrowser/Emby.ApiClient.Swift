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
                    if let data = response.data, let str = String(data: data, encoding: String.Encoding.utf8){
                        print("Server Error: " + str)
                    }
                    failure(EmbyError.NetworkRequestError(error.localizedDescription))
                }
        }
    }
    
    public func sendCollectionRequest<T : JSONSerializable>(request: HttpRequest, success: @escaping ([T]) -> Void, failure: @escaping (EmbyError) -> Void) {
        
        Alamofire.request(request)
            .validate { request, response, data in
                // custom evalution clousre now includes data (allows you to parse data to dig out error messeages
                print(response.description)

                return .success
            }
            .responseJSON { response in
                print(response.result.error?.localizedDescription)
//                if case .success(_) = response.result {
//                    print(response.result.value as? JSON_Object)
//                    if let jsonArray = response.result.value as? JSON_Array {
//
//                        var results: [T] = []
//
//                        for object in jsonArray {
//                            if let jsonObject = object as? JSON_Object, let object = T(jSON: jsonObject) {
//                                results.append(object)
//                            }
//                        }
//
//                        success(results)
//                    }
//                    else {
//                        failure(EmbyError.JsonDeserializationError)
//                    }
//                }
//                else if case .failure(let error) = response.result {
//                    failure(EmbyError.NetworkRequestError(error.localizedDescription))
//                }
                
//                guard response.result.isSuccess else
//                {
//                    let error = response.result as! Error
//                    failure(EmbyError.NetworkRequestError(error.localizedDescription))
//                    return
//                }
                print("JSON_Object: \(response.result.value as? JSON_Object)")
                print("JSON_Array: \(response.result.value as? JSON_Array)")
                print("Raw result value: \(response.result.value)")
                
                if let jsonArray = response.result.value as? JSON_Array {
                    
                    var results: [T] = []
                    
                    for object in jsonArray {
                        if let jsonObject = object as? JSON_Object, let object = T(jSON: jsonObject) {
                            results.append(object)
                        }
                    }
                    
                    print(results)
                    success(results)
                }
                else if let jsonArray = (response.result.value as! JSON_Object)["Items"] as? JSON_Array
                {
                    var results: [T] = []
                    
                    for object in jsonArray {
                        if let jsonObject = object as? JSON_Object, let object = T(jSON: jsonObject) {
                            results.append(object)
                        }
                    }
                    
                    success(results)
                }
                else
                {
                    failure(EmbyError.JsonDeserializationError)
                }
             
                
        }
    }
}

public enum EmbyError: Error {
    
    case JsonDeserializationError
    case NetworkRequestError(String)
}
