//
//  ImageTests.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 9/29/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

@testable import Top100Albums
import XCTest

final class ImageTests: XCTestCase {
  func testAllImagesAreNotNil() {
    for image in Image.allCases {
      XCTAssertNotNil(image.value, "UIImage nil for image: \(image)")
    }
  }
}
