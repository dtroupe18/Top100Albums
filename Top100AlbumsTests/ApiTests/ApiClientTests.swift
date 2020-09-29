//
//  ApiClientTests.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import Top100Albums

final class ApiClientTests: Top100AlbumsTests, Stubable {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testApiClientFetchAlbumsRequest() {
    do {
      let factory = DependencyContainer()
      let apiClient = factory.apiClient

      let urlString = ApiRoute.topAlbums.rawValue
      let stubbedData = try loadDataFrom(filename: .fullStub)

      let httpStub = stub(condition: isAbsoluteURLString(urlString)) { _ in
        return HTTPStubsResponse(data: stubbedData, statusCode: 200, headers: nil)
      }

      let expectation = self.expectation(description: "Wait for stubbed response")

      apiClient.fetchTopAlbums(onSuccess: { response in
        let albums = response.feed.results
        XCTAssert(albums.count == 100)
        expectation.fulfill()

      }, onError: { error in
        fail(message: error.localizedDescription)
        expectation.fulfill()
      })

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
      let apiClient = factory.apiClient

      let urlString = ApiRoute.topAlbums.rawValue
      let stubbedData = try loadDataFrom(filename: .missingAlbumDataStub)

      let httpStub = stub(condition: isAbsoluteURLString(urlString)) { _ in
        return HTTPStubsResponse(data: stubbedData, statusCode: 200, headers: nil)
      }

      let expectation = self.expectation(description: "Wait for stubbed response")

      apiClient.fetchTopAlbums(onSuccess: { response in
        let albums = response.feed.results
        // Only one albums because the other 2 are missing data.
        XCTAssert(albums.count == 1)
        expectation.fulfill()

      }, onError: { error in
        fail(message: error.localizedDescription)
        expectation.fulfill()
      })

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
