//
//  AlbumTableViewCellViewModelTests.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

@testable import Top100Albums
import XCTest

final class AlbumTableViewCellViewModelTests: Top100AlbumsTests, Stubable {
  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testPublicVariableValues() {
    do {
      guard let album = try makeSingleAlbum() else {
        fail(message: "Failed to create album from stub.")
        return
      }

      let viewModel = AlbumTableViewCellViewModel(album: album)
      XCTAssertEqual(viewModel.albumName, album.name)
      XCTAssertEqual(viewModel.artistName, album.artistName)
      XCTAssertNotNil(viewModel.artworkUrl)
      XCTAssertEqual(viewModel.artworkUrl?.absoluteString, album.artworkUrl100)
      XCTAssertNotNil(viewModel.placeholderImage)
    } catch let err {
      fail(message: err.localizedDescription)
    }
  }
}
