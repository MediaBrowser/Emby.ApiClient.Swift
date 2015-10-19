//
//  InstallationInfo.swift
//  Emby.ApiClient
//
//  Created by Corey Vaillancourt on 10/18/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

public struct InstallationInfo {
    let id: String
    let name: String
    let assemblyGuid: String
    let version: String
    let updateClass: PackageVersionClass = .Release
    let percentComplete: Double
}