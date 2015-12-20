//
//  JsonSerializer.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 12/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

public class JsonSerializer: IJsonSerializer {
    
    public init() {
    }
    
    public func DeserializeFromString<T: JSONSerializable>(text: String, type: Any?) throws -> T? {
        
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) where !text.isEmpty {
            
            let json = try NSJSONSerialization.JSONObjectWithData( data, options: [])
            
            if let jsonObject = json as? JSON_Object {
                return T(jSON: jsonObject)
            } else {
                return nil
            }
            
        } else {
            print("no response: '\(text)'")
            
            return nil
        }
    }
    
    public func serializeToString(obj: AnyObject) -> String {
        if let jsonData = try? NSJSONSerialization.dataWithJSONObject(obj, options: []) {
            return String(NSString(data: jsonData, encoding: NSUTF8StringEncoding))
        }
        
        return ""
    }

}