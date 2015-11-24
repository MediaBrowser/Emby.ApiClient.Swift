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
        
        XCTAssertEqual("\(serverAddress)/mediabrowser/Videos/1/2/Subtitles/3/Stream.x?", subtitleUrl)
    }
}
