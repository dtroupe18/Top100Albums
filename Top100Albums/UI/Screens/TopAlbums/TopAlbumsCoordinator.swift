//
//  TopAlbumsCoordinator.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/2/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

protocol TopAlbumsCoordinatorProtocol: CoordinatorProtocol {
  init(apiClient: ApiClientProtocol, navigationController: UINavigationController)
}

protocol TopAlbumsCoordinatorDelegate: AnyObject {
  func topAlbumsUserDidSelectAlbum(_ album: Album)
}

final class TopAlbumsCoordinator: TopAlbumsCoordinatorProtocol {
  private let apiClient: ApiClientProtocol
  private let navigationController: UINavigationController
  private var albumDetailsCoordinator: AlbumDetailsCoordinatorProtocol?

  init(apiClient: ApiClientProtocol, navigationController: UINavigationController) {
    self.apiClient = apiClient
    self.navigationController = navigationController
  }

  func start() {
    let viewModel = TopAlbumsViewModel(apiClient: self.apiClient)
    viewModel.coordinatorDelegate = self
    let viewController = TopAlbumsViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
}

extension TopAlbumsCoordinator: TopAlbumsCoordinatorDelegate {
  func topAlbumsUserDidSelectAlbum(_ album: Album) {
    albumDetailsCoordinator = AlbumDetailsCoordinator(album: album, navigationController: navigationController)
    albumDetailsCoordinator?.parentCoordinatorDelegate = self
    albumDetailsCoordinator?.start()
  }
}

extension TopAlbumsCoordinator: AlbumDetailsCoordinatorDelegate {
  func albumDetailsCoordinatorDidFinish(_: AlbumDetailsCoordinatorProtocol) {
    navigationController.popViewController(animated: true)

    // Release this coordinator from memory.
    albumDetailsCoordinator = nil
  }
}
