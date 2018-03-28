//
//  IJsonSerializer.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation
//package mediabrowser.model.serialization;
//
//import java.io.InputStream;

public typealias JSON_Object = [String : AnyObject]
public typealias JSON_Array = [AnyObject]

public protocol JSONSerializable {
    
    init?(jSON: JSON_Object)
}

//interface
public protocol IJsonSerializer
{
//    /**
//    Serializes to stream.
//    @param obj The obj.
//    @param stream The stream.
//    @exception System.ArgumentNullException obj
//    */
//    void SerializeToStream(Object obj, InputStream stream);
//    
//    /**
//    Serializes to file.
//    
//    @param obj The obj.
//    @param file The file.
//    @exception System.ArgumentNullException obj
//    */
//    void SerializeToFile(Object obj, String file);
//    
//    /**
//    Deserializes from file.
//    
//    @param type The type.
//    @param file The file.
//    @return System.Object.
//    @exception System.ArgumentNullException type
//    */
//    Object DeserializeFromFile(java.lang.Class type, String file);
//    
//    /**
//    Deserializes from file.
//    
//    <typeparam name="T"></typeparam>
//    @param file The file.
//    @return ``0.
//    @exception System.ArgumentNullException file
//    */
//    <T> T DeserializeFromFile(String file);
//    
//    /**
//    Deserializes from stream.
//    <typeparam name="T"></typeparam>
//    @param stream The stream.
//    @return ``0.
//    @exception System.ArgumentNullException stream
//    */
//    <T> T DeserializeFromStream(InputStream stream);
    
    /**
    Deserializes from string.
    
    <typeparam name="T"></typeparam>
    @param text The text.
    @return ``0.
    @exception System.ArgumentNullException text
    */
//    <T> T DeserializeFromString(String text, java.lang.Class type);
//    func DeserializeFromString(text: String, type: Any) throws -> JSON?
    func DeserializeFromString<T: JSONSerializable>(text: String, type: Any?) throws -> T?
//    func DeserializeFromString<T: GenericResult<JSON_Dictionary>>(text: String, type: Any) throws -> T?
    
//    /**
//    Deserializes from stream.
//    @param stream The stream.
//    @param type The type.
//    @return System.Object.
//    @exception System.ArgumentNullException stream
//    */
//    Object DeserializeFromStream(InputStream stream, java.lang.Class type);
//    
//    /**
//    Serializes to string.
//    
//    @param obj The obj.
//    @return System.String.
//    @exception System.ArgumentNullException obj
//    */
//    String SerializeToString(Object obj);
    func serializeToString(obj: AnyObject) -> String
}
