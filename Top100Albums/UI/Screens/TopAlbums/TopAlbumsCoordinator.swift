//
//  TopAlbumsCoordinator.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/2/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

protocol TopAlbumsCoordinatorProtocol: CoordinatorProtocol {}

protocol TopAlbumsCoordinatorDelegate: AnyObject {
  func topAlbumsUserDidSelectAlbum(_ album: Album)
}

private enum ChildCoordinator {
  case albumDetails
}

final class TopAlbumsCoordinator: TopAlbumsCoordinatorProtocol {
  private let albumNetworkClient: AlbumNetworkClientProtocol
  private let navigationController: UINavigationController
  private var childCoordinators: [ChildCoordinator: CoordinatorProtocol] = [:]

  init(albumNetworkClient: AlbumNetworkClientProtocol, navigationController: UINavigationController) {
    self.albumNetworkClient = albumNetworkClient
    self.navigationController = navigationController
  }

  func start() {
    let viewModel = TopAlbumsViewModel(albumNetworkClient: albumNetworkClient)
    viewModel.coordinatorDelegate = self
    let viewController = TopAlbumsViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
}

extension TopAlbumsCoordinator: TopAlbumsCoordinatorDelegate {
  func topAlbumsUserDidSelectAlbum(_ album: Album) {
    let coordinator = AlbumDetailsCoordinator(album: album, navigationController: navigationController)
    coordinator.parentCoordinatorDelegate = self
    childCoordinators[.albumDetails] = coordinator

    coordinator.start()
  }
}

extension TopAlbumsCoordinator: AlbumDetailsCoordinatorDelegate {
  func albumDetailsCoordinatorDidFinish(_: AlbumDetailsCoordinatorProtocol) {
    navigationController.popViewController(animated: true)

    // Release this coordinator from memory.
    childCoordinators[.albumDetails] = nil
  }
}
