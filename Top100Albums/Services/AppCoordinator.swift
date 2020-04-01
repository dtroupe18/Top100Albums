//
//  AppCoordinator.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

protocol AppCoordinatorProtocol: AnyObject {
  init(factory: Factory, navigationController: UINavigationController, window: UIWindow)

  func start()
}

final class AppCoordinator: AppCoordinatorProtocol {
  private let factory: Factory
  private let navigationController: UINavigationController
  private let window: UIWindow

  init(factory: Factory, navigationController: UINavigationController, window: UIWindow) {
    self.factory = factory
    self.navigationController = navigationController
    self.window = window
  }

  public func start() {
    let topAlbumsVC = self.factory.makeTopAlbumsViewController()
    self.navigationController.pushViewController(topAlbumsVC, animated: false)

    self.window.rootViewController = self.navigationController
    self.window.makeKeyAndVisible()
  }
}
