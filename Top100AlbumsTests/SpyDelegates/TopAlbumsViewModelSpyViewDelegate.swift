//
//  TopAlbumsViewModelSpyViewDelegate.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Foundation
import XCTest
@testable import Top100Albums

final class TopAlbumsViewModelSpyViewDelegate: TopAlbumsViewModelViewDelegate {
  public var error: Error?
  public var calledGotResults: Bool = false
  public let asyncExpectation: XCTestExpectation

  init(asyncExpectation: XCTestExpectation) {
    self.asyncExpectation = asyncExpectation
  }

  func topAlbumsViewModel(_ viewModel: TopAlbumsViewModelProtocol, gotError error: Error) {
    self.error = error
    asyncExpectation.fulfill()
  }

  func topAlbumsViewModelGotResults(_ viewModel: TopAlbumsViewModelProtocol) {
    calledGotResults = true
    asyncExpectation.fulfill()
  }
}
