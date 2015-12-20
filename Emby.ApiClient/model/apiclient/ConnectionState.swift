//
//  ConnectionState.swift
//  EmbyApiClient
//
//  Created by Kevin Sullivan on 12/11/15.
//
//

import Foundation

public enum ConnectionState {
    case Unavailable
    case ServerSignIn
    case SignedIn
    case ServerSelection
    case ConnectSignIn
    case OfflineSignIn
    case OfflineSignedIn
}