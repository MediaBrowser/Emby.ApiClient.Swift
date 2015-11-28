//
//  ChapterItemDtoTests.swift
//  EmbyApiClient
//

import XCTest
@testable import EmbyApiClient

class ChapterInfoDtoTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBaseItemPersonHasNoImage() {
        let chapterInfoDto = ChapterInfoDto(name: "name", startPositionTicks: 0)
        
        XCTAssertFalse(chapterInfoDto.hasImage)
    }
    
    func testBaseItemPersonHasImage() {
        var chapterInfoDto = ChapterInfoDto(name: "name", startPositionTicks: 0)
        chapterInfoDto.imageTag = "imageTag"
        
        XCTAssertTrue(chapterInfoDto.hasImage)
    }
}
