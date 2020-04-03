//
//  TopAlbumsViewModel.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Kingfisher
import UIKit

protocol TopAlbumsViewModelViewDelegate: class {
  func topAlbumsViewModel(_ viewModel: TopAlbumsViewModelProtocol, gotError error: Error)
  func topAlbumsViewModelGotResults(_ viewModel: TopAlbumsViewModelProtocol)
}

protocol TopAlbumsViewModelProtocol: UITableViewDataSourcePrefetching {
  var coordinatorDelegate: TopAlbumsCoordinatorDelegate? { get set }
  var viewDelegate: TopAlbumsViewModelViewDelegate? { get set }
  var cellViewModels: [AlbumTableViewCellViewModelProtocol] { get }
  var numberOfSections: Int { get }
  var numberOfRows: Int { get }

  init(apiClient: ApiClientProtocol)

  func fetchTopAlbums()
  func userDidSelectAlbum(_ indexPath: IndexPath)
}

final class TopAlbumsViewModel: NSObject, TopAlbumsViewModelProtocol {
  weak var coordinatorDelegate: TopAlbumsCoordinatorDelegate?
  weak var viewDelegate: TopAlbumsViewModelViewDelegate?

  private let apiClient: ApiClientProtocol
  private var albums: [Album] = []
  private(set) var cellViewModels: [AlbumTableViewCellViewModelProtocol] = []
  let numberOfSections: Int = 1

  var numberOfRows: Int {
    return cellViewModels.count
  }

  init(apiClient: ApiClientProtocol) {
    self.apiClient = apiClient
    super.init()
  }

  func fetchTopAlbums() {
    self.apiClient.fetchTopAlbums(onSuccess: { [weak self] albumResponse in
      guard let self = self else { return }

      self.albums = albumResponse.feed.results
      self.cellViewModels = self.albums.map { AlbumTableViewCellViewModel(album: $0) }
      self.viewDelegate?.topAlbumsViewModelGotResults(self)
      }, onError: { [weak self] error in
        guard let self = self else { return }

        self.viewDelegate?.topAlbumsViewModel(self, gotError: error)
    })
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
