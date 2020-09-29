//
//  AlbumDetailsCoordinator.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/2/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

protocol AlbumDetailsCoordinatorDelegate: AnyObject {
  func albumDetailsCoordinatorDidFinish(_: AlbumDetailsCoordinatorProtocol)
}

protocol AlbumDetailsCoordinatorProtocol: CoordinatorProtocol {
  var parentCoordinatorDelegate: AlbumDetailsCoordinatorDelegate? { get set }
  init(album: Album, navigationController: UINavigationController)
}

final class AlbumDetailsCoordinator: AlbumDetailsCoordinatorProtocol {
  weak var parentCoordinatorDelegate: AlbumDetailsCoordinatorDelegate?
  private let album: Album
  private let navigationController: UINavigationController

  init(album: Album, navigationController: UINavigationController) {
    self.album = album
    self.navigationController = navigationController
  }

  func start() {
    let viewModel = AlbumDetialsViewModel(album: album)
    viewModel.coordinatorDelegate = self
    let viewController = AlbumDetailsViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
}

extension AlbumDetailsCoordinator: AlbumDetialsViewModelCoordinatorDelegate {
  func albumDetialsViewModelDidFinish(_: AlbumDetailsViewModelProtocol) {
    parentCoordinatorDelegate?.albumDetailsCoordinatorDidFinish(self)
  }
}
