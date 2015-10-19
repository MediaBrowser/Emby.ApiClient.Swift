//
//  SystemInfo.swift
//  Emby.ApiClient
//


import Foundation

public class SystemInfo: PublicSystemInfo {
    let operatingSystemDisplayName: String
    let isRunningAsService: Bool
    let supportsRunningAsService: Bool
    let macAddress: String
    let hasPendingRestart: Bool
    let supportsSync: Bool
    let isNetworkDeployed: Bool
    let inProgressInstallations: [InstallationInfo]
    let webSocketPortNumber: Int
    let completedInstallations: [InstallationInfo]
    let canSelfRestart: Bool
    let canSelfUpdate: Bool
    let failedPluginAssemblies: [String]
    let programDataPath: String
    let itemsByNamePath: String
    let cachePath: String
    let logPath: String
    let transcodingTempPath: String
    let httpServerPortNumber: Int
    let supportsHttps: Bool
    let hasUpdatesAvailable: Bool
    let supportsAutoRunAtStartup: Bool
    
    init(localAddress: String?, wanAddress: String?, serverName: String, version: String, operatingSystem: String, id: String, operatingSystemDisplayName: String, isRunningAsService: Bool, supportsRunningAsService: Bool, macAddress: String, hasPendingRestart: Bool, supportsSync: Bool, isNetworkDeployed: Bool,inProgressInstallations: [InstallationInfo], webSocketPortNumber: Int, completedInstallations: [InstallationInfo], canSelfRestart: Bool, canSelfUpdate: Bool, failedPluginAssemblies: [String], programDataPath: String, itemsByNamePath: String, cachePath: String, logPath: String, transcodingTempPath: String, httpServerPortNumber: Int, supportsHttps: Bool, hasUpdatesAvailable: Bool, supportsAutoRunAtStartup: Bool) {

        self.operatingSystemDisplayName = operatingSystemDisplayName
        self.isRunningAsService = isRunningAsService
        self.supportsRunningAsService = supportsRunningAsService
        self.macAddress = macAddress
        self.hasPendingRestart = hasPendingRestart
        self.supportsSync = supportsSync
        self.isNetworkDeployed = isNetworkDeployed
        self.inProgressInstallations = inProgressInstallations
        self.webSocketPortNumber = webSocketPortNumber
        self.completedInstallations = completedInstallations
        self.canSelfRestart = canSelfRestart
        self.canSelfUpdate = canSelfUpdate
        self.failedPluginAssemblies = failedPluginAssemblies
        self.programDataPath = programDataPath
        self.itemsByNamePath = itemsByNamePath
        self.cachePath = cachePath
        self.logPath = logPath
        self.transcodingTempPath = transcodingTempPath
        self.httpServerPortNumber = httpServerPortNumber
        self.supportsHttps = supportsHttps
        self.hasUpdatesAvailable = hasUpdatesAvailable
        self.supportsAutoRunAtStartup = supportsAutoRunAtStartup
        
        super.init(localAddress: localAddress, wanAddress: wanAddress, serverName: serverName, version: version, operatingSystem: operatingSystem, id: id)
    }
}