//
//  UserConfiguration.swift
//  Emby.ApiClient
//

import Foundation

public struct UserConfiguration {
    var audioLanguagePreference: String?
    var playDefaultAudioTrack = true
    var subtitleLanguagePreference: String?
    var displayMissingEpisodes: Bool?
    var displayUnairedEpisodes: Bool?
    var groupMoviesIntoBoxSets: Bool?
    var displayChannelsWithinViews = [String]()
    var excludeFoldersFromGrouping: [String]?
    var groupedFolders = [String]()
    var subtitleMode: SubtitlePlaybackMode?
    var displayCollectionsView = true
    var displayFoldersView: Bool?
    var enableLocalPassword: Bool?
    var orderedViews = [String]()
    var includeTrailersInSuggestions = true
    var enableCinemaMode: Bool?
    var latestItemsExcludes = [String]()
    var plainFolderViews = [String]()
    var hidePlayedInLatest = true
    var displayChannelsInLine: [Bool]?
}