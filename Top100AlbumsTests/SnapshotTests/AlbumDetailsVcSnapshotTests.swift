//
//  AlbumDetailsVcSnapshotTests.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import SnapshotTesting
@testable import Top100Albums
import XCTest

final class AlbumDetailsVcSnapshotTests: BaseSnapshotTests, Stubable {
  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testAlbumDetailsSnapshots() {
    do {
      guard let album = try makeSingleAlbum(callingClass: self) else {
        fail(message: "Failed to load album from stub.")
        return
      }

      let viewModel = AlbumDetailsTestViewModel(album: album)

      for device in self.snapshotDevices {
        let viewController = AlbumDetailsViewController(viewModel: viewModel)
        let navController = UINavigationController(rootViewController: viewController)

        assertSnapshot(
          matching: navController,
          as: .image(on: device.diffImage),
          named: "\(String(describing: AlbumDetailsViewController.self))-\(device.name)"
        )
      }
    } catch let err {
      fail(message: err.localizedDescription)
    }
  }
}
