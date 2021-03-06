//
//  Top100AlbumsTests.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 3/31/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

@testable import Top100Albums
import XCTest

/// Base class for unit tests.
class Top100AlbumsTests: XCTestCase {
  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }
}

public func fail(
  message: String,
  filename: String = #file,
  line: Int = #line
) {
  XCTFail("\(filename) failed \(message) line: \(line)")
}
