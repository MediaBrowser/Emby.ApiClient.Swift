//
//  DeviceProtocol.swift
//  Emby.ApiClient
//

import Foundation

public protocol DeviceProtocol {
    var deviceName: String { get set }
    var deviceId: String { get set }
    
    func getLocalPhotos() -> [LocalFileInfo]
    func getLocalVideos() -> [LocalFileInfo]
    func uploadFile(file: LocalFileInfo, apiClient: ApiClient, progress: ProgressProtocol<Double>, cancellationToken: CancellationToken )
}