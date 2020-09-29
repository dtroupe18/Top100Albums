//
//  TopAlbumsTestViewModel.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

@testable import Top100Albums
import UIKit

/// Test viewModel for UI snapshot) testing only.
final class TopAlbumsMockViewModel: NSObject, TopAlbumsViewModelProtocol, Stubable {
  weak var coordinatorDelegate: TopAlbumsCoordinatorDelegate?
  weak var viewDelegate: TopAlbumsViewModelViewDelegate?

  private var albums: [Album] = []
  var cellViewModels: [AlbumTableViewCellViewModelProtocol] = []
  var numberOfSections: Int = 1

  var numberOfRows: Int {
    return cellViewModels.count
  }

  func fetchTopAlbums() {
    do {
      let albums = try make100Albums()
      self.albums = albums
      cellViewModels = albums.map { AlbumTableViewCellMockViewModel(album: $0) }
      viewDelegate?.topAlbumsViewModelGotResults(self)
    } catch let err {
      Logger.logError(err)
    }
  }

  func userDidSelectAlbum(_ indexPath: IndexPath) {
    let album = albums[indexPath.row]
    coordinatorDelegate?.topAlbumsUserDidSelectAlbum(album)
  }

  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    // Not tested.
  }
}
