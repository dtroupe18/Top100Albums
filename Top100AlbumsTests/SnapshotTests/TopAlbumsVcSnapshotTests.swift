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

final class TopAlbumsVcSnapshotTests: BaseSnapshotTests {
  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testTopAlbumsSnapshots() {
    let mockApiClient = MockApiClient(urlSession: URLSession(configuration: .default))
    let viewModel = TopAlbumsTestViewModel(apiClient: mockApiClient)

    for device in self.snapshotDevices {
      let viewController = TopAlbumsViewController(viewModel: viewModel)
      viewController.hideActivityIndicator()
      let navController = UINavigationController(rootViewController: viewController)

      assertSnapshot(
        matching: navController,
        as: .image(on: device.diffImage),
        named: "\(String(describing: TopAlbumsViewController.self))-\(device.name)"
      )
    }
  }
}