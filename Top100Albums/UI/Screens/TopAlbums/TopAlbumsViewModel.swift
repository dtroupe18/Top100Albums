//
//  TopAlbumsViewModel.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Kingfisher
import UIKit

protocol TopAlbumsViewModelViewDelegate: AnyObject {
  func topAlbumsViewModel(_ viewModel: TopAlbumsViewModelProtocol, gotError error: Error)
  func topAlbumsViewModelGotResults(_ viewModel: TopAlbumsViewModelProtocol)
}

protocol TopAlbumsViewModelProtocol: UITableViewDataSourcePrefetching {
  var coordinatorDelegate: TopAlbumsCoordinatorDelegate? { get set }
  var viewDelegate: TopAlbumsViewModelViewDelegate? { get set }
  var cellViewModels: [AlbumTableViewCellViewModelProtocol] { get }
  var numberOfSections: Int { get }
  var numberOfRows: Int { get }

  func fetchTopAlbums()
  func userDidSelectAlbum(_ indexPath: IndexPath)
}

final class TopAlbumsViewModel: NSObject, TopAlbumsViewModelProtocol {
  weak var coordinatorDelegate: TopAlbumsCoordinatorDelegate?
  weak var viewDelegate: TopAlbumsViewModelViewDelegate?

  private let albumNetworkClient: AlbumNetworkClientProtocol
  private var albums: [Album] = []
  private(set) var cellViewModels: [AlbumTableViewCellViewModelProtocol] = []
  let numberOfSections: Int = 1

  var numberOfRows: Int {
    return cellViewModels.count
  }

  init(albumNetworkClient: AlbumNetworkClientProtocol) {
    self.albumNetworkClient = albumNetworkClient
    super.init()
  }

  func fetchTopAlbums() {
    albumNetworkClient.fetchTopAlbums().done { response in
      self.albums = response.feed.results
      self.cellViewModels = self.albums.map { AlbumTableViewCellViewModel(album: $0) }
      self.viewDelegate?.topAlbumsViewModelGotResults(self)
    }.catch { error in
      self.viewDelegate?.topAlbumsViewModel(self, gotError: error)
    }
  }

  func userDidSelectAlbum(_ indexPath: IndexPath) {
    let album = albums[indexPath.row]
    coordinatorDelegate?.topAlbumsUserDidSelectAlbum(album)
  }
}

// MARK: Prefetching

extension TopAlbumsViewModel: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    let urls = indexPaths.compactMap { cellViewModels[$0.row].artworkUrl }
    ImagePrefetcher(urls: urls).start()
  }
}
