//
//  MockApiClient.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Foundation
@testable import Top100Albums

/// Fake ApiClient that can use used for snapshot testing.
final class MockApiClient: ApiClientProtocol {
  init(urlSession: URLSession) {
    // Not used.
  }

  func fetchTopAlbums(onSuccess: DecodableCallback<AlbumResponse>?, onError: ErrorCallback?) {
    // Not used.
  }
}
