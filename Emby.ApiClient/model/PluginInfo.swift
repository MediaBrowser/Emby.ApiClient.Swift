//
//  PluginInfo.swift
//  EmbyApiClient
//

import Foundation

public struct PluginInfo: JSONSerializable {
    var name: String?
    var configurationDateLastModified: NSDate?
    var version: String?
    var assemblyFileName: String?
    var configurationFileName: String?
    var description: String?
    var id: String?
    var imageUrl: String?
    
    public init?(jSON: JSON_Object) {
        fatalError("init(jSON:) has not been implemented: \(jSON)")
    }
}