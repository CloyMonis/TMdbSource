//
//  HttpClientTests.swift
//  TMdbSource_Tests
//
//  Created by Cloy Monis on 15/03/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import XCTest
@testable import TMdbSource

final class HttpClientTests: XCTestCase {

    var sut: HttpClient?
    var expectation: XCTestExpectation?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testWrongEndPoint() {
        let httpCientModel = HttpClientModel(endpoint: "some wrong endpoint")
        sut = HttpClient()
        expectation = XCTestExpectation(description: "Wrong End Point")
        sut?.fetch(model: httpCientModel, completionHandler: { result in
            switch result {
            case .success(_):
                XCTFail("Should Fail as URL was wrong")
            case .failure(let error):
                let expectedError = HttpClientError.badURL
                XCTAssertTrue(error == expectedError)
                self.expectation?.fulfill()
            }
        })
        wait(for: [expectation!], timeout: 3)
    }
    
    func testMovieEndPoint() {
        let endpoint = "https://api.themoviedb.org/3/movie/popular?language=en-US&page=3&api_key=da30e822b633d40f53a9e6d8da4e8c99"
        let headers = ["accept": "application/json"]
        let clientModel = HttpClientModel(endpoint: endpoint, method: .get, headers: headers)
        expectation = XCTestExpectation(description: "Movie End Point")
        sut?.fetch(model: clientModel, completionHandler: { result in
            switch result {
            case .success(let clientResponse):
                let jsonDecoder = JSONDecoder()
                guard let result: TMdbMovieResult = try? jsonDecoder.decode(TMdbMovieResult.self, from: clientResponse.data) else {
                    XCTFail("Failed")
                    return
                }
                guard let movies = result.results else {
                    XCTFail("Failed")
                    return
                }
                XCTAssertTrue(movies.count == 20)
            case .failure(_):
                XCTFail("Failed")
            }
        })
    }

}
