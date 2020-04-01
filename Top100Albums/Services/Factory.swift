//
//  Factory.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

typealias Factory = DependencyContainerProtocol & ViewControllerFactoryProtocol

protocol ViewControllerFactoryProtocol {
  func makeTopAlbumsViewController() -> TopAlbumsViewController
}

protocol DependencyContainerProtocol {
  var apiClient: ApiClientProtocol { get }
}

final class DependencyContainer: DependencyContainerProtocol {
  private let urlSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = 15 // seconds
    configuration.timeoutIntervalForResource = 30
    return URLSession(configuration: .default)
  }()

  private(set) lazy var apiClient: ApiClientProtocol = {
    return ApiClient(urlSession: self.urlSession)
  }()
}

// MARK: ViewControllerFactory

extension DependencyContainer: ViewControllerFactoryProtocol {
  func makeTopAlbumsViewController() -> TopAlbumsViewController {
    let viewModel = TopAlbumsViewModel(apiClient: self.apiClient)
    return TopAlbumsViewController(viewModel: viewModel)
  }
}
