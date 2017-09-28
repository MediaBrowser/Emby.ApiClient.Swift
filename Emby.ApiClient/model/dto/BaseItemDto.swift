//
//  BaseItemDto.swift
//  Emby.ApiClient
//

import Foundation

public class BaseItemDto : JSONSerializable {
    public var name: String?
    public var serverId: String?
    public var id: String?
    public var etag: String?
    public var playlistItemid: String?
    public var dateCreated: NSDate?
    public var dateLastMediaAdded: NSDate?
    public var extraType: ExtraType?
    public var airsBeforeSeasonNumber: Int?
    public var airsAfterSeasonNumber: Int?
    public var airsBeforeEpisodeNumber: Int?
    public var absoluteEpisodeNumber: Int?
    public var displaySpecialWithSeasons: Bool?
    public var canDelete: Bool?
    public var canDownload: Bool?
    public var hasSubtitles: Bool?
    public var preferredMetadataLanguage: String?
    public var preferredMetadataCountryCode: String?
    public var awardSummary: String?
    public var shareUrl: String?
    public var metascore: Float?
    public var hasDynamicCategories: Bool?
    public var animeSeriesIndex: Int?
    public var supportsSync: Bool?
    public var hasSyncJob: Bool?
    public var isSynced: Bool?
    public var syncStatus: SyncJobStatus?
    public var syncPercent: Double?
    public var dvdSeasonNumber: Int?
    public var dvdEpisodeNumber: Int?
    public var sortName: String?
    public var forcedSortName: String?
    public var video3dFormat: Video3DFormat?
    public var premierDate: NSDate?
    public var externalUrls: [ExternalUrl]?
    public var mediaSources: [MediaSourceInfo]?
    public var criticRating: Float?
    public var gameSystem: String?
    public var criticRatingSummary: String?
    public var multiPartGameFiles: [String]?
    public var path: String?
    public var officialRating: String?
    public var customRating: String?
    public var channelId: String?
    public var channelName: String?
    public var overview: String?
    public var shortOverview: String?
    public var tmdbCollectionName: String?
    public var tagLines: [String]?
    public var genres: [String]?
    public var seriesGenres: [String]?
    public var communityRating: Float?
    public var voteCount: Int?
    public var cumulativeRunTimeTicks: Int?
    public var originalRunTimeTicks: Int?
    public var runTimeTicks: Int?
    public var playAccess: PlayAccess?
    public var aspectRation: String?
    public var productionYear: Int?
    public var players: Int?
    public var isPlaceHolder: Bool?
    public var indexNumber: Int?
    public var indexNumberEnd: Int?
    public var parentIndexNumber: Int?
    public var remoteTrailers: [MediaUrl]?
    public var soundtrackIds: [String]?
    public var providerIds: [String:String]?
    public var isHd: Bool?
    public var isFolder: Bool?
    public var parentId: String?
    public var type: String?
    public var people: [BaseItemPerson]?
    public var studios: [StudioDto]?
    public var parentLogoItemId: String?
    public var parentBackdropItemId: String?
    public var parentBackdropImageTags: [String]?
    public var localTrailerCount: Int?
    public var userData: UserItemDataDto?
    public var seasonUserData: UserItemDataDto?
    public var recursiveItemCount: Int?
    public var childCount: Int?
    public var seriesName: String?
    public var seriesId: String?
    public var seasonId: String?
    public var specialFeatureCount: Int?
    public var displayPreferencesId: String?
    public var status: String?
    public var seriesStatus: SeriesStatus? {
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
    
    public var recordingStatus: RecordingStatus? {
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
    
    public var airTime: String?
    public var airDays: [String]?
    public var indexOptions: [String]?
    public var tags: [String]?
    public var keywords: [String]?
    public var primaryImageAspectRatio: Double?
    public var originalPrimaryImageAspectRatio: Double?
    public var artists: [String]?
    public var artistItems: [NameIdPair]?
    public var album: String?
    public var collectionType: String?
    public var displayOrder: String?
    public var albumId: String?
    public var albumPrimaryImageTag: String?
    public var seriesPrimaryImageTag: String?
    public var albumArtist: String?
    public var albumArtists: [NameIdPair]?
    public var seasonName: String?
    public var mediaStreams: [MediaStream]?
    public var videoType: VideoType?
    public var displayMediaType: String?
    public var partCount: Int?
    public var mediaSourceCount: Int?
    
    public var supportsPlayLists: Bool {
        get {
            return (runTimeTicks != nil) || ((isFolder != nil) && isFolder!) || isGenre || isMusicGenre || isArtist
        }
    }
    
    public func isType(type: String) -> Bool {
        return self.type == type
    }
    
    public var imageTags: [ImageType: String]?
    public var backdropImageTags: [String]?
    public var screenshotImageTags: [String]?
    public var parentLogoImageTag: String?
    public var parentArtItemId: String?
    public var parentArtImageTag: String?
    public var seriesThumbImageTag: String?
    public var seriesStudio: String?
    public var parentThumbItemId: String?
    public var parentThumbImageTag: String?
    public var parentPrimaryImageItemId: String?
    public var parentPrimaryImageTag: String?
    public var chapters: [ChapterInfoDto]?
    public var locationType: LocationType?
    public var isoType: IsoType?
    public var mediaType: String?
    public var endDate: NSDate?
    public var homePageUrl: String?
    public var productionLocations: [String]?
    public var budget: Double?
    public var revenue: Double?
    public var lockedFields: [MetadataFields]?
    public var movieCount: Int?
    public var seriesCount: Int?
    public var episodeCount: Int?
    public var gameCount: Int?
    public var songCount: Int?
    public var albumCount: Int?
    public var musicVideoCount: Int?
    public var lockData: Bool?
    public var width: Int?
    public var height: Int?
    public var cameraMake: String?
    public var cameraModel: String?
    public var software: String?
    public var exposureTime: Double?
    public var focalLength: Double?
    public var imageOrientation: ImageOrientation?
    public var aperture: Double?
    public var shutterSpeed: Double?
    public var latitude: Double?
    public var longitude: Double?
    public var altitude: Double?
    public var isoSpeedRating: Int?
    public var recordingCount: Int?
    public var seriesTimerId: String?
    public var canResume: Bool {
        get {
            if let playbackPositionTicks = userData?.playbackPositionTicks {
                return playbackPositionTicks > 0
            } else {
                return false
            }
        }
    }
    
    public var resumePositionTicks: Int {
        get {
            if let playbackPositionTicks = userData?.playbackPositionTicks {
                return playbackPositionTicks
            } else {
                return 0
            }
        }
    }
    
    public var backdropCount: Int {
        get {
            return (backdropImageTags != nil) ? backdropImageTags!.count : 0
        }
    }
    
    public var screenshotCount: Int {
        get {
            return (screenshotImageTags != nil) ? screenshotImageTags!.count : 0
        }
    }
    
    public var hasBanner: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Banner] != nil : false
        }
    }
    
    public var hasArtImage: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Art] != nil : false
        }
    }
    
    public var hasLogo: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Logo] != nil : false
        }
    }
    
    public var hasThumb: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Thumb] != nil : false
        }
    }
    
    public var hasPrimaryImage: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Primary] != nil : false
        }
    }
    
    public var hasDiscImage: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Disc] != nil : false
        }
    }
    
    public var hasBoxImage: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Box] != nil : false
        }
    }
    
    public var hasBoxRearImage: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.BoxRear] != nil : false
        }
    }
    
    public var hasMenuImage: Bool {
        get {
            return (imageTags != nil) ? imageTags![ImageType.Menu] != nil : false
        }
    }
    
    public var isVideo: Bool {
        get {
            return mediaType == MediaType.Video.rawValue
        }
    }
    
    public var isGame: Bool {
        get {
            return mediaType == MediaType.Game.rawValue
        }
    }
    
    public var isPerson: Bool {
        get {
            return mediaType == "Person"
        }
    }
    
    public var isRoot: Bool {
        get {
            return mediaType == "AggregateFolder"
        }
    }
    
    public var isMusicGenre: Bool {
        get {
            return mediaType == "MusicGenre"
        }
    }
    
    public var isGameGenre: Bool {
        get {
            return mediaType == "GameGenre"
        }
    }
    
    public var isGenre: Bool {
        get {
            return mediaType == "Genre"
        }
    }
    
    public var isArtist: Bool {
        get {
            return mediaType == "MusicArtist"
        }
    }
    
    public var isAlbum: Bool {
        get {
            return mediaType == "MusicAlbum"
        }
    }
    
    public var IsStudio: Bool {
        get {
            return mediaType == "Studio"
        }
    }
    
    public var supportsSimilarItems: Bool {
        get {
            return isType(type: "Movie") || isType(type: "Series") || isType(type: "MusicAlbum") || isType(type: "MusicArtist") || isType(type: "Program") || isType(type: "Recording") || isType(type: "ChannelVideoItem") || isType(type: "Game")
        }
    }
    
    public var programId: String?
    public var channelPrimaryImageTag: String?
    public var startDate: NSDate?
    public var completionPercentage: Double?
    public var isRepeat: Bool?
    public var episodeTitle: String?
    public var channelType: ChannelType?
    public var audio: ProgramAudio?
    public var isMovie: Bool?
    public var isSports: Bool?
    public var isSeries: Bool?
    public var isLive: Bool?
    public var isNews: Bool?
    public var isKids: Bool?
    public var isPremiere: Bool?
    public var timerId: String?
    public var currentProgram: BaseItemDto?
    
    public required init?(jSON: JSON_Object) {
        //fatalError("init(jSON:) has not been implemented: \(jSON)")
        self.name = jSON["Name"] as? String
    }
}
