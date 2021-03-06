//
//  ApiRouteTests.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 9/29/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

@testable import Top100Albums
import XCTest

final class ApiRouteTests: XCTestCase {
  func testApiRouteUrlsAreNotNil() {
    for route in ApiRoute.allCases {
      XCTAssertNotNil(route.url, "Url nil for route: \(route)")
    }
  }
}
