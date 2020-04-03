//
//  AlbumResponseDecodeTests.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/2/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import XCTest
@testable import Top100Albums

final class AlbumResponseDecodeTests: Top100AlbumsTests, StubLoading {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testAlbumResponseDecodeWorks() {
    do {
      let jsonData = try loadDataFrom(filename: .fullStub, fileType: .json, callingClass: self)
      let albumResponse = try JSONDecoder().decode(AlbumResponse.self, from: jsonData)
      let albumCount = albumResponse.feed.results.count

      XCTAssertTrue(albumCount == 100, "Expected to decode 100 albums but only decoded: \(albumCount)")

    } catch let err {
      fail(message: err.localizedDescription)
    }
  }
}
