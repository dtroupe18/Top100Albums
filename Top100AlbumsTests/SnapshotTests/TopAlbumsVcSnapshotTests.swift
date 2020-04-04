//
//  TopAlbumsVcSnapshotTests.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Top100Albums

final class TopAlbumsVcSnapshotTests: BaseSnapshotTests, StubLoading {
  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testTopAlbumsSnapshots() {
    do {
      let albums = try make100Albums(callingClass: self)
      let cellViewModels = albums.map { AlbumTableViewCellTestViewModel(album: $0) }
      let viewModel = TopAlbumsTestViewModel(cellViewModels: cellViewModels)

      for device in self.snapshotDevices {
        let viewController = TopAlbumsViewController(viewModel: viewModel)
        viewController.topAlbumsViewModelGotResults(viewModel)
        let navController = UINavigationController(rootViewController: viewController)

        assertSnapshot(
          matching: navController,
          as: .image(on: device.diffImage),
          named: "\(String(describing: TopAlbumsViewController.self))-\(device.name)"
        )
      }
    } catch let err {
      fail(message: err.localizedDescription)
    }
  }
}
