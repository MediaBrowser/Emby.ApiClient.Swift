//
//  QueryStringDictionary.swift
//  Emby.ApiClient
//
//  Created by Vedran Ozir on 07/10/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

//package mediabrowser.apiinteraction;
//
//import java.net.URLEncoder;
//import java.util.ArrayList;

/**
Class QueryStringDictionary
*/
public class QueryStringDictionary //extends java.util.HashMap<String, String>
{
    var data: [String: String] = [:]
    
//    /**
//    Initializes a new instance of the <see cref="QueryStringDictionary" /> class.
//    */
//    public QueryStringDictionary()
//    {
//        super();
//    }
    
    /**
    Adds the specified name.
    
    @param name The name.
    @param value The value.
    */
    public final func Add(name: String, value: Int)
    {
        data[name] = String(value)
    }
    
    /**
    Adds the specified name.
    @param name The name.
    @param value The value.
    */
    public final func Add(name: String, value: String?)
    {
        data[name] = value ?? ""
    }

//    /**
//    Adds the specified name.
//    
//    @param name The name.
//    @param value The value.
//    */
//    public final void Add(String name, long value)
//    {
//        self.put(name, (new Long(value)).toString());
//    }
//    
//    /**
//    Adds the specified name.
//    
//    @param name The name.
//    @param value The value.
//    */
//    public final void Add(String name, double value)
//    {
//        self.put(name, (new Double(value)).toString());
//    }
//    
    public final func addIfNotNil(name: String, value: String?) {
        if let val = value {
            data[name] = val
        }
    }
    
    public final func addIfNotNilOrEmpty(name: String, value: String?) {
        if let val = value where !val.isEmpty {
            addIfNotNil(name, value: value)
        }
    }

    public final func addIfNotNil(name: String, value: Int?) {
        if let val = value {
            data[name] = String(val)
        }
    }
//    
//    /**
//    Adds if not null.
//    
//    @param name The name.
//    @param value The value.
//    */
//    public final void AddIfNotNull(String name, Double value)
//    {
//        if (value != null)
//        {
//            self.Add(name, value);
//        }
//    }
    public final func addIfNotNil(name: String, value: Double?) {
        if let val = value {
            data[name] = String(val)
        }
    }
//    
//    /**
//    Adds if not null.
//    
//    @param name The name.
//    @param value The value.
//    */
//    public final void AddIfNotNull(String name, Long value)
//    {
//        if (value != null)
//        {
//            self.Add(name, value);
//        }
//    }
//    
//    /**
//    Adds the specified name.
//    
//    @param name The name.
//    @param value if set to <c>true</c> [value].
//    */
//    public final void Add(String name, boolean value)
//    {
//        self.put(name, (new Boolean(value)).toString());
//    }
//    
//    /**
//    Adds if not null.
//    
//    @param name The name.
//    @param value if set to <c>true</c> [value].
//    */
//    public final void AddIfNotNull(String name, Boolean value)
//    {
//        if (value != null)
//        {
//            self.Add(name, value);
//        }
//    }
    
    public final func addIfNotNil(name: String, value: Bool?) {
        if let val = value {
            data[name] = String(val)
        }
    }
//    
//    /**
//    Adds the specified name.
//    
//    @param name The name.
//    @param value The value.
//    @exception System.ArgumentNullException value
//    */
//    public final void Add(String name, Integer[] value)
//    {
//        if (value == null)
//        {
//            throw new IllegalArgumentException("value");
//        }
//        
//        String attValue = tangible.DotNetToJavaStringHelper.join(",", GetStrings(value));
//        
//        self.put(name, attValue);
//    }
//    
//    private String[] GetStrings(Integer[] value)
//    {
//        String[] vals = new String[value.length];
//        
//        for (int i=0; i< value.length; i++) {
//            vals[i] = value[i].toString();
//        }
//        
//        return vals;
//    }
//    
//    public final void Add(String name, int[] value)
//    {
//        if (value == null)
//        {
//            throw new IllegalArgumentException("value");
//        }
//        
//        String attValue = tangible.DotNetToJavaStringHelper.join(",", GetStrings(value));
//        
//        self.put(name, attValue);
//    }
//    
//    private String[] GetStrings(int[] value)
//    {
//        String[] vals = new String[value.length];
//        
//        for (int i=0; i< value.length; i++) {
//            vals[i] = new Integer(value[i]).toString();
//        }
//        
//        return vals;
//    }
//    
//    /**
//    Adds if not null.
//    @param name The name.
//    @param value The value.
//    */
//    public final void AddIfNotNull(String name, int[] value)
//    {
//        if (value != null)
//        {
//            self.Add(name, value);
//        }
//    }
//    
//    /**
//    Adds if not null.
//    
//    @param name The name.
//    @param value The value.
//    */
//    public final void AddIfNotNull(String name, Integer[] value)
//    {
//        if (value != null)
//        {
//            self.Add(name, value);
//        }
//    }
    public final func add(name: String, value: [Int]?) {
        if let val = value {
            data[name] = val.map({String($0)}).joinWithSeparator(",")
        }
    }
//    
//    /**
//    Adds the specified name.
//    
//    @param name The name.
//    @param value The value.
//    @exception System.ArgumentNullException value
//    */
//    public final void Add(String name, String[] value)
//    {
//        if (value == null)
//        {
//            throw new IllegalArgumentException("value");
//        }
//        
//        Add(name, value, ",");
//    }
    
    public final func add(name: String, value: [String]?) {
        if let val = value {
            data[name] = val.joinWithSeparator(",")
        }
    }
//    
//    /**
//    Adds the specified name.
//    @param name The name.
//    @param value The value.
//    @exception System.ArgumentNullException value
//    */
//    public final void Add(String name, ArrayList<String> value)
//    {
//        if (value == null)
//        {
//            throw new IllegalArgumentException("value");
//        }
//        
//        String[] stringArray = value.toArray(new String[value.size()]);
//        
//        Add(name, stringArray);
//    }
//    
//    /**
//    Adds if not null.
//    
//    @param name The name.
//    @param value The value.
//    */
//    public final void AddIfNotNull(String name, String[] value)
//    {
//        if (value != null)
//        {
//            self.Add(name, value);
//        }
//    }
//    
//    /**
//    Adds the specified name.
//    
//    @param name The name.
//    @param value The value.
//    @param delimiter The delimiter.
//    */
//    public final void Add(String name, String[] value, String delimiter)
//    {
//        if (value == null)
//        {
//            throw new IllegalArgumentException("value");
//        }
//        
//        String paramValue = tangible.DotNetToJavaStringHelper.join(delimiter, value);
//        
//        self.put(name, paramValue);
//    }
//    
//    /**
//    Adds if not null.
//    
//    @param name The name.
//    @param value The value.
//    @param delimiter The delimiter.
//    */
//    public final void AddIfNotNull(String name, String[] value, String delimiter)
//    {
//        if (value != null)
//        {
//            self.Add(name, value, delimiter);
//        }
//    }
//    
//    /**
//    Adds if not null.
//    @param name The name.
//    @param value The value.
//    */
//    public final void AddIfNotNull(String name, ArrayList<String> value)
//    {
//        if (value != null)
//        {
//            self.Add(name, value);
//        }
//    }
    
    /**
    Gets the query string.
    
    @return System.String.
    */
    public final func GetQueryString() -> String
    {
        var vals = [String]()
        
        for (index, value) in data
        {
//            let paramValue = data[index];
//            vals[index] = String.format("%1$s=%2$s", key, GetEncodedValue(paramValue));
            vals.append("\(index)=\(GetEncodedValue(value))")
//            index++;
        }
        
//        return tangible.DotNetToJavaStringHelper.join("&", vals);
        return vals.joinWithSeparator("&")
    }
    
    /**
    Gets the encoded value.
    
    @param value The value.
    @return System.String.
    */
    private func GetEncodedValue(value: String) -> String
    {
        return value.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) ?? ""
    }
    
    public final func getUrl(prefix: String) -> String {
        return prefix + "?" + GetQueryString()
    }

    //public final func addIfNotNil(name: String, value: CustomStringConvertible?) {
    //    if let val = value {
    //        data[name] = val.description
    //    }
    //}
    
    //public final func addIfNotNil(name: String, value: [CustomStringConvertible]?) {
    //    if let val = value {
    //        data[name] = val.map({$0.description}).joinWithSeparator(",")
    //    }
    //}
//
//    public final <T extends Enum<T>> void Add(String name, T value)
//    {
//        self.Add(name, value.toString());
//    }
//    
//    public final <T extends Enum<T>> void AddIfNotNull(String name, T value)
//    {
//        if (value != null)
//        {
//            self.Add(name, value);
//        }
//    }
//    
//    public final <T extends Enum<T>> void Add(String name, T[] values, String delimiter)
//    {
//        self.Add(name, GetStrings(values), delimiter);
//    }
//    
//    public final <T extends Enum<T>> void AddIfNotNull(String name, T[] values, String delimiter)
//    {
//        if (values != null)
//        {
//            self.Add(name, values, delimiter);
//        }
//    }
//    
//    public final <T extends Enum<T>> void Add(String name, T[] values)
//    {
//        self.Add(name, values, ",");
//    }
//    
//    public final <T extends Enum<T>> void AddIfNotNull(String name, T[] values)
//    {
//        self.AddIfNotNull(name, values, ",");
//    }
//    
//    private <T extends Enum<T>> String[] GetStrings(T[] value)
//    {
//        String[] vals = new String[value.length];
//        
//        for (int i=0; i< value.length; i++) {
//            vals[i] = value[i].toString();
//        }
//        
//        return vals;
//    }
}