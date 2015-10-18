//
//  DeviceProtocol.swift
//  Emby.ApiClient
//

import Foundation

public protocol DeviceProtocol {
    let deviceName: String
    let deviceId: String
    
    func getLocalPhotos() -> [LocalFileInfo]
    func getLocalVideos)() -> [LocalFileInfo]
    func uploadFile(file: LocalFileInfo, apiClient: ApiClient, progress: ProgressProtocol<Double>, cancellationToken: CancellationToken )
}