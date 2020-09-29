//
//  AppCoordinator.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol: AnyObject {
  func start()
}

protocol AppCoordinatorProtocol: CoordinatorProtocol {}

final class AppCoordinator: AppCoordinatorProtocol {
  private let factory: Factory
  private let navigationController: UINavigationController
  private let window: UIWindow
  private let topAlbumsCoordinator: TopAlbumsCoordinatorProtocol

  init(factory: Factory, navigationController: UINavigationController, window: UIWindow) {
    self.factory = factory
    self.navigationController = navigationController
    self.window = window

    self.topAlbumsCoordinator = TopAlbumsCoordinator(
      apiClient: factory.apiClient,
      navigationController: navigationController
    )
  }

  public func start() {
    window.rootViewController = navigationController
    topAlbumsCoordinator.start()
    window.makeKeyAndVisible()
  }
}
