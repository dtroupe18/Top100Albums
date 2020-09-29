//
//  AlbumNetworkClientTests.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import OHHTTPStubs
@testable import Top100Albums
import XCTest

final class AlbumNetworkClientTests: Top100AlbumsTests, Stubable {
  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testApiClientFetchAlbumsRequest() {
    do {
      let factory = DependencyContainer()
      let networkClient = factory.albumNetworkClient

      let urlString = ApiRoute.topAlbums.rawValue
      let stubbedData = try loadDataFrom(filename: .fullStub)

      let httpStub = stub(condition: isAbsoluteURLString(urlString)) { _ in
        HTTPStubsResponse(data: stubbedData, statusCode: 200, headers: nil)
      }

      let expectation = self.expectation(description: "Wait for stubbed response")

      networkClient.fetchTopAlbums().done { response in
        let albums = response.feed.results
        XCTAssert(albums.count == 100)
        expectation.fulfill()
      }.catch { error in
        fail(message: error.localizedDescription)
        expectation.fulfill()
      }

      self.waitForExpectations(timeout: 5.0, handler: { error in
        HTTPStubs.removeStub(httpStub)

        if let err = error {
          fail(message: err.localizedDescription)
        }
      })
    } catch let err {
      fail(message: err.localizedDescription)
    }
  }

  func testApiClientFetchAlbumsRequestWithMissingData() {
    do {
      let factory = DependencyContainer()
      let networkClient = factory.albumNetworkClient

      let urlString = ApiRoute.topAlbums.rawValue
      let stubbedData = try loadDataFrom(filename: .missingAlbumDataStub)

      let httpStub = stub(condition: isAbsoluteURLString(urlString)) { _ in
        HTTPStubsResponse(data: stubbedData, statusCode: 200, headers: nil)
      }

      let expectation = self.expectation(description: "Wait for stubbed response")

      networkClient.fetchTopAlbums().done { response in
        let albums = response.feed.results
        // Only one albums because the other 2 are missing data.
        XCTAssert(albums.count == 1)
        expectation.fulfill()
      }.catch { error in
        fail(message: error.localizedDescription)
        expectation.fulfill()
      }

      self.waitForExpectations(timeout: 5.0, handler: { error in
        HTTPStubs.removeStub(httpStub)

        if let err = error {
          fail(message: err.localizedDescription)
        }
      })
    } catch let err {
      fail(message: err.localizedDescription)
    }
  }
}
