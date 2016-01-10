//
//  BaseItemDtoTests.swift
//  EmbyApiClient
//

import XCTest
@testable import EmbyApiClient

class BaseItemDtoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitializationFailsWithoutId() {
        let emptyJson = JSON_Object()
        
        let badBaseItemDto = BaseItemDto(jSON: emptyJson)
        XCTAssertNil(badBaseItemDto, "An ID is required")
    }
    
    func testInitializationSuccessWithId() {
        let id = "4998a9df017164441770ad3fefea42f1"
        let jsonObject = convertJsonStringToDictionary("{ \"Id\": \"\(id)\" }")!
        
        let baseItemDto = BaseItemDto(jSON: jsonObject)
        XCTAssertEqual(id, baseItemDto!.id)
    }

    func testInitializationOfMovie() {
        let json = loadJsonFileToJsonObject("BaseItemDtoTests_Movie")!
        
        let baseItemDto = BaseItemDto(jSON: json)!
        
        XCTAssertEqual("4998a9df017164441770ad3fefea42f1", baseItemDto.id)
        XCTAssertEqual("Elysium", baseItemDto.name)
        XCTAssertEqual("39621c8d93d2f9b6cd0b86d579356f69", baseItemDto.serverId)
        XCTAssertFalse(baseItemDto.canDelete!)
        XCTAssertTrue(baseItemDto.canDownload!)
        XCTAssertNotNil(baseItemDto.dateCreated)
        XCTAssertEqual("1 win & 7 nominations.", baseItemDto.awardSummary)
        XCTAssertEqual(61.0, baseItemDto.metascore)
        XCTAssertTrue(baseItemDto.supportsSync!)
        XCTAssertFalse(baseItemDto.hasSyncJob!)
        XCTAssertFalse(baseItemDto.isSynced!)
        XCTAssertEqual("elysium", baseItemDto.sortName)
        XCTAssertNotNil(baseItemDto.premiereDate)
        XCTAssertEqual(2, baseItemDto.externalUrls?.count, "Should have two external URLs")
        XCTAssertTrue(baseItemDto.externalUrls!.contains({$0.name == "IMDb"}))
        XCTAssertTrue(baseItemDto.externalUrls!.contains({$0.url == "http://www.imdb.com/title/tt1535108"}))
        XCTAssertEqual(68.0, baseItemDto.criticRating)
        XCTAssertEqual("After the heady sci-fi thrills of District 9, Elysium is a bit of a comedown for director Neill Blomkamp, but on its own terms, it delivers just often enough to satisfy.", baseItemDto.criticRatingSummary)
        XCTAssertEqual("F:\\media\\film\\Elysium (2013)\\Elysium (2013).m4v", baseItemDto.path)
        XCTAssertEqual("R", baseItemDto.officialRating)
        XCTAssertEqual("In the year 2159, two classes of people exist: the very wealthy who live on a pristine man-made space station called Elysium, and the rest, who live on an overpopulated, ruined Earth. Secretary Rhodes (Jodie Foster), a hard line government ofﬁcial, will stop at nothing to enforce anti-immigration laws and preserve the luxurious lifestyle of the citizens of Elysium. That doesn’t stop the people of Earth from trying to get in, by any means they can. When unlucky Max (Matt Damon) is backed into a corner, he agrees to take on a daunting mission that, if successful, will not only save his life, but could bring equality to these polarized worlds.", baseItemDto.overview)
        XCTAssertEqual("In the year 2154, the very wealthy live on a man-made space station while the rest of the population resides on a ruined Earth. A man takes on a mission that could bring equality to the polarized worlds.", baseItemDto.shortOverview)
        XCTAssertEqual(1, baseItemDto.tagLines?.count, "Should have one tagline")
        XCTAssertEqual("He can save us all.", baseItemDto.tagLines![0])
        XCTAssertEqual(3, baseItemDto.genres?.count, "Should have three genres")
        XCTAssertTrue(baseItemDto.genres!.contains({$0 == "Drama"}), "Find one of the genres")
        XCTAssertEqual(6.7, baseItemDto.communityRating)
        XCTAssertEqual(248061, baseItemDto.voteCount)
        XCTAssertEqual(65755870000, baseItemDto.runTimeTicks)
        XCTAssertEqual(PlayAccess.Full, baseItemDto.playAccess)
        XCTAssertEqual(2013, baseItemDto.productionYear)
        XCTAssertFalse(baseItemDto.isPlaceHolder!)
        XCTAssertTrue(baseItemDto.isHd!)
        XCTAssertFalse(baseItemDto.isFolder!)
        XCTAssertEqual("3ba29c88311a3ef5b6aaeaf5a952487c", baseItemDto.parentId)
        XCTAssertEqual("Movie", baseItemDto.type)
        XCTAssertEqual(0, baseItemDto.localTrailerCount)
        XCTAssertEqual("dbf7709c41faaa746463d67978eb863d", baseItemDto.displayPreferencesId)
        XCTAssertTrue(baseItemDto.tags!.isEmpty)
        XCTAssertEqual(2, baseItemDto.keywords?.count, "Should have two keywords")
        XCTAssertTrue(baseItemDto.keywords!.contains({$0 == "class conflict"}), "Find one of the keywords")
        XCTAssertEqual(0.666666666666667, baseItemDto.primaryImageAspectRatio)
        XCTAssertEqual(0.666666666666667, baseItemDto.originalPrimaryImageAspectRatio)
        XCTAssertEqual(VideoType.VideoFile, baseItemDto.videoType)
        XCTAssertEqual(4, baseItemDto.backdropImageTags?.count, "Should have four image tags")
        XCTAssertTrue(baseItemDto.backdropImageTags!.contains({$0 == "711cb7a465c1a8f76574c1f240b5d1ec"}), "Find one of the tags")
        XCTAssertEqual(0, baseItemDto.screenshotImageTags?.count)
        XCTAssertEqual(LocationType.FileSystem, baseItemDto.locationType)
        XCTAssertEqual("Video", baseItemDto.mediaType)
        XCTAssertEqual("http://www.itsbetterupthere.com/site/", baseItemDto.homePageUrl)
        XCTAssertEqual(1, baseItemDto.productionLocations?.count, "Should have one location")
        XCTAssertTrue(baseItemDto.productionLocations!.contains({$0 == "United States of America"}), "Find one of the locations")
        XCTAssertEqual(115000000.0, baseItemDto.budget)
        XCTAssertEqual(286140700.0, baseItemDto.revenue)
        XCTAssertFalse(baseItemDto.lockData!)
    }

    private func convertJsonStringToDictionary(jsonString: String) -> JSON_Object? {
        if let utf8Data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(utf8Data, options: .MutableContainers) as? JSON_Object
                return json
            } catch {
                fatalError("Failure to convert \(jsonString) to JSON_Object")
            }
        }
        return nil
    }
    
    private func loadJsonFile(fileName: String) -> String? {
        print("Attempting to load file: \(fileName)")
        
        let bundle = NSBundle(forClass: self.dynamicType)
        if let path = bundle.pathForResource(fileName, ofType: "json") {
            print("Full path to file: \(path)")
            do {
                let jsonString = try String(contentsOfURL: NSURL(fileURLWithPath: path), encoding: NSUTF8StringEncoding)
                return jsonString
            } catch {
                fatalError("Unable to load file: \(path)")
            }
        }
        return nil
    }
    
    private func loadJsonFileToJsonObject(fileName: String) -> JSON_Object? {
        if let jsonString = loadJsonFile(fileName) {
            return convertJsonStringToDictionary(jsonString)
        } else {
            print("Unable to load JSON for file: \(fileName)")
            return nil
        }
    }
}
