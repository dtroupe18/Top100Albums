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
  var albums: [Album] { get }
  var numberOfSections: Int { get }
  var numberOfRows: Int { get }

  init(apiClient: ApiClientProtocol)

  func fetchTopAlbums()
  func userDidSelectAlbum(_ album: Album)
}

final class TopAlbumsViewModel: NSObject, TopAlbumsViewModelProtocol {
  weak var coordinatorDelegate: TopAlbumsCoordinatorDelegate?
  weak var viewDelegate: TopAlbumsViewModelViewDelegate?

  private let apiClient: ApiClientProtocol
  private(set) var albums: [Album] = []
  let numberOfSections: Int = 1

  var numberOfRows: Int {
    return albums.count
  }

  init(apiClient: ApiClientProtocol) {
    self.apiClient = apiClient
    super.init()
  }

  func fetchTopAlbums() {
    self.apiClient.fetchTopAlbums(onSuccess: { [weak self] albumResponse in
      guard let self = self else { return }

      self.albums = albumResponse.feed.results
      self.viewDelegate?.topAlbumsViewModelGotResults(self)
      }, onError: { [weak self] error in
        guard let self = self else { return }

        self.viewDelegate?.topAlbumsViewModel(self, gotError: error)
    })
  }

  func userDidSelectAlbum(_ album: Album) {
    coordinatorDelegate?.topAlbumsUserDidSelectAlbum(album)
  }
}

// MARK: Prefetching

extension TopAlbumsViewModel: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    let urls = indexPaths.compactMap {
      URL(string: albums[$0.row].artworkUrl100)
    }

    ImagePrefetcher(urls: urls).start()
  }
}
