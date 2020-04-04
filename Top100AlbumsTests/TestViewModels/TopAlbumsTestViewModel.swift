//
//  TopAlbumsTestViewModel.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit
import XCTest
@testable import Top100Albums

/// Test viewModel for UI snapshot) testing only.
final class TopAlbumsTestViewModel: NSObject, TopAlbumsViewModelProtocol {
  weak var coordinatorDelegate: TopAlbumsCoordinatorDelegate?
  weak var viewDelegate: TopAlbumsViewModelViewDelegate?

  var cellViewModels: [AlbumTableViewCellViewModelProtocol] = []
  var numberOfSections: Int = 1

  var numberOfRows: Int {
    return cellViewModels.count
  }

  init(apiClient: ApiClientProtocol) {
    fatalError("init(apiClient:) has not been implemented. Use init(expectation:) for testing.")
  }

  init(cellViewModels: [AlbumTableViewCellViewModelProtocol]) {
    self.cellViewModels = cellViewModels
  }

  func fetchTopAlbums() {
    viewDelegate?.topAlbumsViewModelGotResults(self)
  }

  func userDidSelectAlbum(_ indexPath: IndexPath) {
    let album = cellViewModels[indexPath.row].album
    coordinatorDelegate?.topAlbumsUserDidSelectAlbum(album)
  }

  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    // Not tested.
  }
}
