//
//  AlbumDetialsViewModelTests.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import XCTest
@testable import Top100Albums

final class AlbumDetialsViewModelTests: Top100AlbumsTests, StubLoading {
  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testPublicVariableValues() {
    do {
      guard let album = try makeSingleAlbum(callingClass: self) else {
        fail(message: "Failed to create album from stub.")
        return
      }

      let viewModel = AlbumDetialsViewModel(album: album)

      XCTAssertEqual(viewModel.albumName, album.name)
      XCTAssertEqual(viewModel.artist, album.artistName)

      // One Genre because "Music" is removed.
      XCTAssertEqual(viewModel.genres.count, 1)
      XCTAssertEqual(viewModel.genreNamesString, album.genres.first?.name)
      XCTAssertEqual(viewModel.releaseDateStr, "Feb 28, 2020")
      XCTAssertEqual(viewModel.copyright, album.copyright)
      XCTAssertNotNil(viewModel.itunesUrl)
      XCTAssertNotNil(viewModel.imageUrl)
      XCTAssertNotNil(viewModel.placeholder)
    } catch let err {
      fail(message: err.localizedDescription)
    }
  }
}
