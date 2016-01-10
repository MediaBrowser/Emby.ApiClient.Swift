//
//  BaseApiClientTests.swift
//  Emby.ApiClient
//

import XCTest
@testable import EmbyApiClient

class BaseApiClientTests: XCTestCase {
    let logger = Logger()
    let jsonSerializer = JsonSerializer()
    let serverAddress = "http://localhost"
    let clientName = "TestClient"
    let device = iOSDevice()
    let applicationVersion = "1"
    var baseApiClient: BaseApiClient?
    let baseItemDto = BaseItemDto(jSON: ["Id": "TestId"])!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        self.baseApiClient = BaseApiClient(logger: logger, jsonSerializer: jsonSerializer, serverAddress: serverAddress, clientName: clientName, device: device, applicationVersion: applicationVersion)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testApiUrl() {
        let apiUrl = baseApiClient!.getApiUrl()
        
        XCTAssertEqual("\(serverAddress)/mediabrowser", apiUrl)
    }
    
    func testSubtitleUrl() {
        let subtitleDownloadOptions = SubtitleDownloadOptions(itemId: "1", mediaSourceId: "2", streamIndex: 3, format: "x")

        let subtitleUrl = baseApiClient!.getSubtitleUrl(subtitleDownloadOptions)
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/Videos/1/2/Subtitles/3/Stream.x", subtitleUrl)
    }
    
    //public final func setJsonSerializer(value: IJsonSerializer) {
    //public final func getJsonSerializer() -> IJsonSerializer? {
    //public final func setClientName(value: String) {
    //public final func getClientName() -> String? {
    //public final func setApplicationVersion(value: String) {
    //public final func getApplicationVersion() -> String? {
    //public final func setServerAddress(value: String) {
    //public final func getServerAddress() -> String {
    //public final func setAccessToken(value: String?) {
    //public final func getAccessToken() -> String? {
    //public final func getDevice() -> DeviceProtocol? {
    //public final func getDeviceName() -> String? {
    //public final func getDeviceId() -> String? {
    //public final func setImageQuality(value: Int) {
    //public final func getImageQuality() -> Int? {
    //public final func setCurrentUserId(value: String?) {
    //public final func getCurrentUserId() -> String? {
    

    
    //public final func changeServerLocation(address: String) {
    //public func setAuthenticationInfo(accessToken: String?, userId: String?) {
    //public func setAuthenticationInfo(accessToken: String?) {
    //public func clearAuthenticationInfo() {
    
    func testGetApiUrlWithHandler() {
        let handler = "handler";
        
        let apiUrl = baseApiClient!.getApiUrl(handler)
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/handler", apiUrl)
    }
    
    func testGetImageUrlWithBaseItemDtoForBackdropImage() {
        baseItemDto.id = "imageId";
        baseItemDto.backdropImageTags = ["png"]
        
        var options = ImageOptions()
        options.imageType = ImageType.Backdrop
        options.imageIndex = 0
        
        let imageUrl = baseApiClient!.getImageUrl(baseItemDto, options: options)
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/Items/\(baseItemDto.id!)/Images/\(options.imageType)?EnableImageEnhancers=\(options.enableImageEnhancers)&Tag=png", imageUrl)
    }
    
    func testGetImageUrlWithBaseItemDtoForScreenshotImage() {
        baseItemDto.id = "imageId";
        baseItemDto.screenshotImageTags = ["png"]
        
        var options = ImageOptions()
        options.imageType = ImageType.Screenshot
        options.imageIndex = 0
        
        let imageUrl = baseApiClient!.getImageUrl(baseItemDto, options: options)
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/Items/\(baseItemDto.id!)/Images/\(options.imageType)?EnableImageEnhancers=\(options.enableImageEnhancers)&Tag=png", imageUrl)
    }
    
    func testGetImageUrlWithBaseItemDtoForChapterImage() {
        var chapterInfoDto = ChapterInfoDto(name: "chapter1", startPositionTicks: 0)
        chapterInfoDto.imageTag = "png"
        
        baseItemDto.id = "imageId";
        baseItemDto.chapters = [chapterInfoDto]
        
        var options = ImageOptions()
        options.imageType = ImageType.Chapter
        options.imageIndex = 0
        
        let imageUrl = baseApiClient!.getImageUrl(baseItemDto, options: options)
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/Items/\(baseItemDto.id!)/Images/\(options.imageType)?EnableImageEnhancers=\(options.enableImageEnhancers)&Tag=png", imageUrl)
    }
    
    func testGetImageUrlWithBaseItemDtoDefaultCase() {
        baseItemDto.id = "imageId";
        baseItemDto.imageTags = [ImageType.Primary: "png"]
        
        var options = ImageOptions()
        options.imageType = ImageType.Primary
        
        let imageUrl = baseApiClient!.getImageUrl(baseItemDto, options: options)
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/Items/\(baseItemDto.id!)/Images/\(options.imageType)?EnableImageEnhancers=\(options.enableImageEnhancers)&Tag=png", imageUrl)
    }
    
    func testGetImageUrlFromItemId() {
        let itemId = "imageId"
        
        var options = ImageOptions()
        options.imageType = ImageType.Backdrop
        
        let imageUrl = baseApiClient!.getImageUrl(itemId, options: options)
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/Items/\(itemId)/Images/\(options.imageType)?EnableImageEnhancers=\(options.enableImageEnhancers)", imageUrl)
    }

    func testGetUserImageUrl() {
        var user = UserDto()
        user.id = "userId"
        
        var options = ImageOptions()
        options.imageType = ImageType.Primary
        
        let userImageUrl = baseApiClient!.getUserImageUrl(user, options: options)
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/Users/\(user.id!)/Images/\(options.imageType)?EnableImageEnhancers=\(options.enableImageEnhancers)", userImageUrl)
    }
    
    func testGetUserImageUrlByUserId() {
        let userId = "userId"
        
        var options = ImageOptions()
        options.imageType = ImageType.Primary
        
        let userImageUrl = baseApiClient!.getUserImageUrl(userId, options: options)
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/Users/\(userId)/Images/\(options.imageType)?EnableImageEnhancers=\(options.enableImageEnhancers)", userImageUrl)
    }
    
    func testGetPersonImageUrl() {
        let baseItemPerson = BaseItemPerson(name: "person", role: "role", type: "person")
        baseItemPerson.id = "personId";
        baseItemPerson.primaryImageTag = "primaryImageTag"
        
        let options = ImageOptions()
        let personImageUrl = baseApiClient!.getPersonImageUrl(baseItemPerson, options: options)
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/Items/\(baseItemPerson.id!)/Images/\(options.imageType)?EnableImageEnhancers=\(options.enableImageEnhancers)&Tag=\(baseItemPerson.primaryImageTag!)", personImageUrl)
    }
   
    func testGetGenreImageUrl() {
        let name = "genre"
        let options = ImageOptions()
        
        let genreImageUrl = try! baseApiClient!.getGenreImageUrl(name, options: options)
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/Genres/\(name)/Images/\(options.imageType)?EnableImageEnhancers=\(options.enableImageEnhancers)", genreImageUrl)
    }
    
    func testGetGenreImageUrlThrowsErrorTypeForEmptyName() {
        do {
            try baseApiClient!.getGenreImageUrl("", options: ImageOptions())
            XCTFail("Expected IllegalArgumentError.EmptyString")
        } catch {
        }
    }
    
    func testGetMusicGenreImageUrl() {
        let name = "musicGenre"
        let options = ImageOptions()
        
        let musicGenreImageUrl = try! baseApiClient!.getMusicGenreImageUrl(name, options: options)
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/MusicGenres/\(name)/Images/\(options.imageType)?EnableImageEnhancers=\(options.enableImageEnhancers)", musicGenreImageUrl)
    }
    
    func testGetMusicGenreImageUrlThrowsErrorTypeForEmptyName() {
        do {
            try baseApiClient!.getMusicGenreImageUrl("", options: ImageOptions())
            XCTFail("Expected IllegalArgumentError.EmptyString")
        } catch {
        }
    }
    
    func testGetGameGenreImageUrl() {
        let name = "gameGenre"
        let options = ImageOptions()
        
        let gameGenreImageUrl = try! baseApiClient!.getGameGenreImageUrl(name, options: options)
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/GameGenres/\(name)/Images/\(options.imageType)?EnableImageEnhancers=\(options.enableImageEnhancers)", gameGenreImageUrl)
    }
    
    func testGetGameGenreImageUrlThrowsErrorTypeForEmptyName() {
        do {
            try baseApiClient!.getGameGenreImageUrl("", options: ImageOptions())
            XCTFail("Expected IllegalArgumentError.EmptyString")
        } catch {
        }
    }
    
    func testGetStudioImageUrl() {
        let name = "studio"
        let options = ImageOptions()
        
        let studioImageUrl = try! baseApiClient!.getStudioImageUrl(name, options: options)
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/Studios/\(name)/Images/\(options.imageType)?EnableImageEnhancers=\(options.enableImageEnhancers)", studioImageUrl)
    }
    
    func testGetStudioImageUrlThrowsErrorTypeForEmptyName() {
        do {
            try baseApiClient!.getStudioImageUrl("", options: ImageOptions())
            XCTFail("Expected IllegalArgumentError.EmptyString")
        } catch {
        }
    }

    func testGetArtistImageUrl() {
        let name = "artist"
        let options = ImageOptions()
        
        let artistImageUrl = try! baseApiClient!.getArtistImageUrl(name, options: options)
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/Artists/\(name)/Images/\(options.imageType)?EnableImageEnhancers=\(options.enableImageEnhancers)", artistImageUrl)
    }
    
    func testGetArtistImageUrlThrowsErrorTypeForEmptyName() {
        do {
            try baseApiClient!.getArtistImageUrl("", options: ImageOptions())
            XCTFail("Expected IllegalArgumentError.EmptyString")
        } catch {
        }
    }


    //TODO: Remaining unit tests
    //public final func getBackdropImageUrls(item: BaseItemDto, var options: ImageOptions) -> [String]? {
    //public final func getLogoImageUrl(item: BaseItemDto, var options: ImageOptions) throws -> String? {
    //public final func getThumbImageUrl(item: BaseItemDto, var options: ImageOptions) throws -> String? {
    //public final func getArtImageUrl(item: BaseItemDto, var options: ImageOptions) throws -> String? {
    //public func getIsoString(date: NSDate) -> String {

    // Unit test internal func?
}
