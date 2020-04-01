//
//  TopAlbumsViewModel.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Foundation

protocol TopAlbumsViewModelViewDelegate: class {
  func topAlbumsViewModel(_ viewModel: TopAlbumsViewModelProtocol, gotError error: Error)
  func topAlbumsViewModelGotResults(_ viewModel: TopAlbumsViewModelProtocol)
}

protocol TopAlbumsViewModelProtocol: AnyObject {
  var viewDelegate: TopAlbumsViewModelViewDelegate? { get set }
  var response: AlbumResponse? { get } // qwe

  init(apiClient: ApiClientProtocol)

  func fetchTopAlbums()
}

final class TopAlbumsViewModel: TopAlbumsViewModelProtocol {
  weak var viewDelegate: TopAlbumsViewModelViewDelegate?
  private(set) var response: AlbumResponse?

  private let apiClient: ApiClientProtocol

  init(apiClient: ApiClientProtocol) {
    self.apiClient = apiClient
  }

  func fetchTopAlbums() {
    self.apiClient.fetchTopAlbums(onSuccess: { [weak self] albumResponse in
      guard let self = self else { return }

      self.response = albumResponse
      self.viewDelegate?.topAlbumsViewModelGotResults(self)
    }, onError: { [weak self] error in
      guard let self = self else { return }

      self.viewDelegate?.topAlbumsViewModel(self, gotError: error)
    })
  }
}
