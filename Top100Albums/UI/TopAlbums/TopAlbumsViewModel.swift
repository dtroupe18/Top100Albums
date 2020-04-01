//
//  TopAlbumsViewModel.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Foundation

protocol TopAlbumsViewModelProtocol: AnyObject {
  init(apiClient: ApiClientProtocol)
}

final class TopAlbumsViewModel: TopAlbumsViewModelProtocol {
  private let apiClient: ApiClientProtocol

  init(apiClient: ApiClientProtocol) {
    self.apiClient = apiClient
  }
}
