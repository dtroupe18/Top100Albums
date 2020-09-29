//
//  Factory.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Alamofire
import UIKit

typealias Factory = DependencyContainerProtocol

protocol DependencyContainerProtocol {
  var apiClient: ApiClientProtocol { get }
  var albumNetworkClient: AlbumNetworkClientProtocol { get }
}

final class DependencyContainer: DependencyContainerProtocol {
  private(set) lazy var apiClient: ApiClientProtocol = self.makeApiClient()
  private(set) lazy var albumNetworkClient: AlbumNetworkClientProtocol = self.makeAlbumNetworkClient()

  private func makeApiClient() -> ApiClientProtocol {
    let interceptor = ApiRequestInterceptor()
    let connectionObserver = NetworkConnectionObserver()
    let session = Session(configuration: .default, interceptor: interceptor)

    return ApiClient(session: session, networkConnectionObserver: connectionObserver)
  }

  private func makeAlbumNetworkClient() -> AlbumNetworkClientProtocol {
    return AlbumNetworkClient(apiClient: self.apiClient)
  }
}
