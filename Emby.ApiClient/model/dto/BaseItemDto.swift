//
//  BaseItemDto.swift
//  Emby.ApiClient
//

import Foundation

public class BaseItemDto {
    var name: String?
    var serverId: String?
    var id: String?
    var etag: String?
    var playlistItemid: String?
    var dateCreated: NSDate?
    var dateLastMediaAdded: NSDate?
    var extraType: ExtraType?
    var airsBeforeSeasonNumber: Int?
    var airsAfterSeasonNumber: Int?
    var airsBeforeEpisodeNumber: Int?
    var absoluteEpisodeNumber: Int?
    var displaySpecialWithSeasons: Bool?
    var canDelete: Bool?
    var canDownload: Bool?
    var hasSubtitles: Bool?
    var preferredMetadataLanguage: String?
    var preferredMetadataCountryCode: String?
    var awardSummary: String?
    var shareUrl: String?
    var metascore: Float?
    var hasDynamicCategories: Bool?
    var animeSeriesIndex: Int?
    var supportsSync: Bool?
    var hasSyncJob: Bool?
    var isSynced: Bool?
    var syncStatus: SyncJobStatus?
    var syncPercent: Double?
    var dvdSeasonNumber: Int?
    var dvdEpisodeNumber: Int?
    var sortName: String?
    var forcedSortName: String?
    var video3dFormat: Video3DFormat?
    var premierDate: NSDate?
    var externalUrls: [ExternalUrl]?
    var mediaSources: [MediaSourceInfo]?
    var criticRating: Float?
    var gameSystem: String?
    var criticRatingSummary: String?
    var multiPartGameFiles: [String]?
    var path: String?
    var officialRating: String?
    var customRating: String?
    var channelId: String?
    var channelName: String?
    var overview: String?
    var shortOverview: String?
    var tmdbCollectionName: String?
    var tagLines: [String]?
    var genres: [String]?
    var seriesGenres: [String]?
    var communityRating: Float?
    var voteCount: Int?
    var cumulativeRunTimeTicks: Int?
    var originalRunTimeTicks: Int?
    var runTimeTicks: Int?
    var playAccess: PlayAccess?
    var aspectRation: String?
    var productionYear: Int?
    var players: Int?
    var isPlaceHolder: Bool?
    var indexNumber: Int?
    var indexNumberEnd: Int?
    var parentIndexNumber: Int?
    var remoteTrailers: [MediaUrl]?
    var soundtrackIds: [String]?
    var providerIds: [String:String]?
    var isHd: Bool?
    var isFolder: Bool?
    var parentId: String?
    var type: String?
    var people: [BaseItemPerson]?
    var studios: [StudioDto]?
    var parentLogoItemId: String?
    var parentBackdropItemId: String?
    var parentBackdropImageTags: [String]?
    var localTrailerCount: Int?
    var userData: UserItemDataDto?
    var seasonUserData: UserItemDataDto?
    var recursiveItemCount: Int?
    var childCount: Int?
    var seriesName: String?
    var seriesId: String?
    var seasonId: String?
    var specialFeatureCount: Int?
    var displayPreferencesId: String?
    var status: String?
    var seriesStatus: SeriesStatus? {
        get {
            if let status = self.status {
                return SeriesStatus(rawValue: status)
            } else {
                return nil
            }
        }
        
        set {
            status = newValue!.rawValue
        }
    }
    
    var recordingStatus: RecordingStatus? {
        get {
            if let status = self.status {
                return RecordingStatus(rawValue: status)
            } else {
                return nil
            }
        }
        
        set {
            status = newValue!.rawValue
        }
    }
    
    var airTime: String?
    var airDays: [String]?
    var indexOptions: [String]?
    var tags: [String]?
    var keywords: [String]?
    var primaryImageAspectRatio: Double?
    var originalPrimaryImageAspectRatio: Double?
    var artists: [String]?
    var artistItems: [NameIdPair]?
    var album: String?
    var collectionType: String?
    var displayOrder: String?
    var albumId: String?
    var albumPrimaryImageTag: String?
    var seriesPrimaryImageTag: String?
    var albumArtist: String?
    var albumArtists: [NameIdPair]?
    var seasonName: String?
    var mediaStreams: [MediaStream]?
    var videoType: VideoType?
    var displayMediaType: String?
    var partCount: Int?
    var mediaSourceCount: Int?
    
    var supportsPlayLists: Bool {
        get {
            return (runTimeTicks != nil) || ((isFolder != nil) && isFolder!) || isGenre || isMusicGenre || isArtist
        }
    }
    
    public func isType(type: String) -> Bool {
        return self.type == type
    }
    
    var imageTags: [ImageType: String]?
    var backdropImageTags: [String]?
    var screenshotImageTags: [String]?
    var parentLogoImageTag: String?
    var parentArtItemId: String?
    var parentArtImageTag: String?
    var seriesThumbImageTag: String?
    var seriesStudio: String?
    var parentThumbItemId: String?
    var parentThumbImageTag: String?
    var parentPrimaryImageItemId: String?
    var parentPrimaryImageTag: String?
    var chapters: [ChapterInfoDto]?
    var locationType: LocationType?
    var isoType: IsoType?
    var mediaType: String?
    var endDate: NSDate?
    var homePageUrl: String?
    var productionLocations: [String]?
    var budget: Double?
    var revenue: Double?
    var lockedFields: [MetadataFields]?
    var movieCount: Int?
    var seriesCount: Int?
    var episodeCount: Int?
    var gameCount: Int?
    var songCount: Int?
    var albumCount: Int?
    var musicVideoCount: Int?
    var lockData: Bool?
    var width: Int?
    var height: Int?
    var cameraMake: String?
    var cameraModel: String?
    var software: String?
    var exposureTime: Double?
    var focalLength: Double?
    var imageOrientation: ImageOrientation?
    var aperture: Double?
    var shutterSpeed: Double?
    var latitude: Double?
    var longitude: Double?
    var altitude: Double?
    var isoSpeedRating: Int?
    var recordingCount: Int?
    var seriesTimerId: String?
    var canResume: Bool {
        get {
            if let playbackPositionTicks = userData?.playbackPositionTicks {
                return playbackPositionTicks > 0
            } else {
                return false
            }
        }
    }
    
    var resumePositionTicks: Int {
        get {
            if let playbackPositionTicks = userData?.playbackPositionTicks {
                return playbackPositionTicks
            } else {
                return 0
            }
        }
    }
    
    var backdropCount: Int {
        get {
            return (backdropImageTags != nil) ? backdropImageTags!.count : 0
        }
    }
    
    var screenshotCount: Int {
        get {
            return (screenshotImageTags != nil) ? screenshotImageTags!.count : 0
        }
    }
    
    var hasBanner: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Banner] != nil : false
        }
    }
    
    var hasArtImage: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Art] != nil : false
        }
    }
    
    var hasLogo: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Logo] != nil : false
        }
    }
    
    var hasThumb: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Thumb] != nil : false
        }
    }
    
    var hasPrimaryImage: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Primary] != nil : false
        }
    }
    
    var hasDiscImage: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Disc] != nil : false
        }
    }
    
    var hasBoxImage: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Box] != nil : false
        }
    }
    
    var hasBoxRearImage: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.BoxRear] != nil : false
        }
    }
    
    var hasMenuImage: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Menu] != nil : false
        }
    }
    
    var isVideo: Bool {
        get {
            return mediaType == MediaType.Video.rawValue
        }
    }
    
    var isGame: Bool {
        get {
            return mediaType == MediaType.Game.rawValue
        }
    }
    
    var isPerson: Bool {
        get {
            return mediaType == "Person"
        }
    }
    
    var isRoot: Bool {
        get {
            return mediaType == "AggregateFolder"
        }
    }
    
    var isMusicGenre: Bool {
        get {
            return mediaType == "MusicGenre"
        }
    }
    
    var isGameGenre: Bool {
        get {
            return mediaType == "GameGenre"
        }
    }
    
    var isGenre: Bool {
        get {
            return mediaType == "Genre"
        }
    }
    
    var isArtist: Bool {
        get {
            return mediaType == "MusicArtist"
        }
    }
    
    var isAlbum: Bool {
        get {
            return mediaType == "MusicAlbum"
        }
    }
    
    var IsStudio: Bool {
        get {
            return mediaType == "Studio"
        }
    }
    
    var supportsSimilarItems: Bool {
        get {
            return isType("Movie") || isType("Series") || isType("MusicAlbum") || isType("MusicArtist") || isType("Program") || isType("Recording") || isType("ChannelVideoItem") || isType("Game")
        }
    }
    
    var programId: String?
    var channelPrimaryImageTag: String?
    var startDate: NSDate?
    var completionPercentage: Double?
    var isRepeat: Bool?
    var episodeTitle: String?
    var channelType: ChannelType?
    var audio: ProgramAudio?
    var isMovie: Bool?
    var isSports: Bool?
    var isSeries: Bool?
    var isLive: Bool?
    var isNews: Bool?
    var isKids: Bool?
    var isPremiere: Bool?
    var timerId: String?
    var currentProgram: BaseItemDto?
}