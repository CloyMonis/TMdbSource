//
//  TmdbDataSourceTests.swift
//  TMdbSource_Tests
//
//  Created by Cloy Monis on 15/03/24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import XCTest
@testable import TMdbSource

final class TmdbDataSourceTests: XCTestCase {
    
    var sut: TMdbDataSource?
    var expectation: XCTestExpectation?

    override func setUpWithError() throws {
        sut = TMdbDataSource()
        expectation = XCTestExpectation(description: "TMDB Source Test")
    }

    override func tearDownWithError() throws {
        sut = nil
        expectation = nil
    }

    func testMovieListFailure() {
        sut?.getMovies(pageNo: 0, category: .popular, completion: { movies in
            self.expectation?.fulfill()
            XCTAssertTrue(movies.isEmpty)
        })
        wait(for: [expectation!], timeout: 3)
    }
    
    func testMovieListPopularSuccess() {
        sut?.getMovies(pageNo: 1, category: .popular, completion: { movies in
            self.expectation?.fulfill()
            XCTAssertTrue(movies.count == 20)
        })
        wait(for: [expectation!], timeout: 3)
    }

    func testMovieListLatestSuccess() {
        sut?.getMovies(pageNo: 1, category: .latest, completion: { movies in
            self.expectation?.fulfill()
            XCTAssertTrue(movies.count == 20)
        })
        wait(for: [expectation!], timeout: 3)
    }
    
    func testMovieDetail() {
        sut = TMdbDataSource()
        sut?.getMovieDetail(id: 838209, completion: { movie in
            self.expectation?.fulfill()
            guard let title = movie?.title else {
                XCTFail("Movie Details Fetching Failed")
                return
            }
            XCTAssertTrue(title == "Exhuma")
        })
        wait(for: [expectation!], timeout: 3)
    }
    
}
