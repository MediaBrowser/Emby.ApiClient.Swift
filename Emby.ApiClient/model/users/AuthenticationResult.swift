//
//  AuthenticationResult.swift
//  EmbyApiClient
//
//  Created by Kevin Sullivan on 12/14/15.
//
//

import Foundation

public struct AuthenticationResult : JSONSerializable {
    public let user: UserDto
    public let sessionInfo: SessionInfoDto
    public let accessToken: String
    public let serverId: String
    
    public init?(jSON: JSON_Object) {
        if  let accessToken = jSON["AccessToken"] as? String,
            let serverId = jSON["ServerId"] as? String,
            let userJSON = jSON["User"] as? JSON_Object,
            let sessionInfoJSON = jSON["SessionInfo"] as? JSON_Object,
            let user = UserDto(jSON: userJSON)
        {
            self.accessToken = accessToken
            self.serverId = serverId
            
            self.user = user
            self.sessionInfo = SessionInfoDto(jSON: sessionInfoJSON)!
        }
        else {
            return nil
        }
    }
}