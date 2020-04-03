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

      XCTAssertTrue(albumCount == 100, "Expected to decode 100 albums decoded: \(albumCount) albums")

    } catch let err {
      fail(message: err.localizedDescription)
    }
  }

  func testAlbumResponseWithMissingAlbumDataDecodeWorks() {
    do {
      let jsonData = try loadDataFrom(filename: .missingAlbumDataStub, fileType: .json, callingClass: self)
      let albumResponse = try JSONDecoder().decode(AlbumResponse.self, from: jsonData)
      let albumCount = albumResponse.feed.results.count

      XCTAssertTrue(albumCount == 1, "Expected to decode 1 albums decoded: \(albumCount) albums.")

    } catch let err {
      fail(message: err.localizedDescription)
    }
  }

  func testAlbumResponseValuesAreDecodedCorrectly() {
    do {
      let jsonData = try loadDataFrom(filename: .oneAlbumStub, fileType: .json, callingClass: self)
      let albumResponse = try JSONDecoder().decode(AlbumResponse.self, from: jsonData)

      let albumCount = albumResponse.feed.results.count
      XCTAssertTrue(albumCount == 1, "Expected to decode 1 albums decoded: \(albumCount) albums.")

      guard let album = albumResponse.feed.results.first else {
        fail(message: "Failed to decode album.")
        return
      }

      XCTAssert(album.artistName == "Lil Baby")
      XCTAssert(album.id == "1498988850")
      XCTAssert(album.releaseDate == "2020-02-28")
      XCTAssert(album.name == "My Turn")

      // swiftlint:disable:next line_length
      XCTAssert(album.copyright == "Quality Control Music/Motown Records; ℗ 2020 Quality Control Music, LLC, under exclusive license to UMG Recordings, Inc.")
      XCTAssert(album.artistID == "1276656483")
      XCTAssert(album.contentAdvisoryRating == "Explicit")

      XCTAssert(album.artistURL == "https://music.apple.com/us/artist/lil-baby/1276656483?app=music")
      XCTAssert(album.artworkUrl100 == "https://is2-ssl.mzstatic.com/image/thumb/Music124/v4/dd/25/8c/dd258c8a-f804-785f-1268-ad3cac0db873/20UMGIM04591.rgb.jpg/200x200bb.png")

      XCTAssert(album.genres.count == 2)
      XCTAssert(album.genres.first?.name == "Hip-Hop/Rap")
      XCTAssert(album.genres.last?.name == "Music")
      XCTAssert(album.url == "https://music.apple.com/us/album/my-turn/1498988850?app=music")
    } catch let err {
      fail(message: err.localizedDescription)
    }
  }
}
