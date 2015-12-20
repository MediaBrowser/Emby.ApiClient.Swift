//
//  ConnectionResult.swift
//  Emby.ApiClient
//
//  Created by Corey Vaillancourt on 10/18/15.
//  Copyright © 2015 Vedran Ozir. All rights reserved.
//

import Foundation

public struct ConnectionResult {
    public var state: ConnectionState = .Unavailable
    public var servers: [ServerInfo] = []
    public var apiClient: ApiClient?
    public var connectUser: ConnectUser?
}