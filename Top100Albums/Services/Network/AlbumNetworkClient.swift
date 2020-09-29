//
//  AlbumNetworkClient.swift
//  Top100Albums
//
//  Created by Dave Troupe on 9/29/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Alamofire
import Foundation
import PromiseKit

protocol AlbumNetworkClientProtocol {
  func fetchTopAlbums() -> Promise<AlbumResponse>
}

final class AlbumNetworkClient: AlbumNetworkClientProtocol {
  private let apiClient: ApiClientProtocol

  init(apiClient: ApiClientProtocol) {
    self.apiClient = apiClient
  }

  public func fetchTopAlbums() -> Promise<AlbumResponse> {
    return apiClient.makeRequest(method: .get, route: .topAlbums, paramObject: EmptyParameters())
  }
}
