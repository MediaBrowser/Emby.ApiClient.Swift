//
//  ApiEventListener.swift
//  EmbyApiClient
//

import Foundation

public protocol ApiEventListener {
    func onRemoteLoggedOut(client: ApiClient, reason: RemoteLogoutReason)
    func onUserUpdated(client: ApiClient, userDto: UserDto)
    func onUserConfigurationUpdated(client: ApiClient, userDto: UserDto)
    func onBrowseCommand(apiClient: ApiClient, command: BrowseRequest)
    func onPlayCommand(client: ApiClient, command: PlayRequest)
    func onPlaystateCommand(client: ApiClient, command: PlaystateRequest)
    func onMessageCommand(client: ApiClient, command: MessageCommand)
    func onGeneralCommand(client: ApiClient, commmand: GeneralCommand)
    func onSendStringCommand(client: ApiClient, value: String)
    func onSetVolumeCommand(client: ApiClient, value: Int)
    func onSetAudioStreamIndexCommand(client: ApiClient, value: Int)
    func onSetSubtitleStreamIndexCommand(client: ApiClient, value: Int)
    func onUserDataChanged(client: ApiClient, info: UserDataChangeInfo)
    func onSessionsUpdated(client: ApiClient, args: SessionUpdatesEventArgs)
    func onPlaybackStart(client: ApiClient, info: SessionInfoDto)
    func onPlaybackStopped(client: ApiClient, info: SessionInfoDto)
    func onSessionEnded(client: ApiClient, info: SessionInfoDto)
}