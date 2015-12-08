//
//  DeviceIdentification.swift
//  Emby.ApiClient
//

import Foundation

public struct DeviceIdentification {
    var friendlyName: String?
    var modelNumber: String?
    var serialNumber: String?
    var modelName: String?
    var modelDescription: String?
    var deviceDescription: String?
    var modelUrl: String?
    var manufacturer: String?
    var manufacturerUrl: String?
    var headers = [HttpHeaderInfo]()
}