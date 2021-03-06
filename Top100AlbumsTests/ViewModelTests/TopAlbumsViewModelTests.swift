//
//  TopAlbumsViewModelTests.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import OHHTTPStubs
@testable import Top100Albums
import XCTest

final class TopAlbumsViewModelTests: Top100AlbumsTests, Stubable {
  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testFetchTopAlbums() {
    do {
      let factory = DependencyContainer()
      let viewModel = TopAlbumsViewModel(albumNetworkClient: factory.albumNetworkClient)
      let expectation = self.expectation(description: "Wait for stubbed response")
      let spyDelegate = TopAlbumsViewModelSpyViewDelegate(asyncExpectation: expectation)
      viewModel.viewDelegate = spyDelegate

      XCTAssertNil(spyDelegate.error)
      XCTAssertFalse(spyDelegate.calledGotResults)
      XCTAssertTrue(viewModel.cellViewModels.isEmpty)
      XCTAssertTrue(viewModel.numberOfRows == 0)
      XCTAssertTrue(viewModel.numberOfSections == 1)

      let urlString = ApiRoute.topAlbums.rawValue
      let stubbedData = try loadDataFrom(filename: .fullStub)

      let httpStub = stub(condition: isAbsoluteURLString(urlString)) { _ in
        HTTPStubsResponse(data: stubbedData, statusCode: 200, headers: nil)
      }

      viewModel.fetchTopAlbums()

      self.waitForExpectations(timeout: 5.0, handler: { error in
        HTTPStubs.removeStub(httpStub)

        if let err = error {
          fail(message: err.localizedDescription)
        }

        XCTAssertTrue(spyDelegate.calledGotResults)
        XCTAssertTrue(viewModel.cellViewModels.count == 100)
        XCTAssertTrue(viewModel.numberOfRows == 100)
        XCTAssertTrue(viewModel.numberOfSections == 1)
      })
    } catch let err {
      fail(message: err.localizedDescription)
    }
  }
}
