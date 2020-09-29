//
//  BaseSnapshotTests.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Top100Albums

public struct PhoneForSnapshotTesting {
  let name: String
  let diffImage: ViewImageConfig

  init(config: ViewImageConfig, name: String) {
    if config.size == nil {
      assertionFailure("ScreenSize nil for \(name)")
    }

    self.diffImage = config.self
    self.name = name
  }
}

class BaseSnapshotTests: XCTestCase {
  final let iPhoneSe = PhoneForSnapshotTesting(config: ViewImageConfig.iPhoneSe(.portrait), name: "iPhoneSe")
  final let iPhone8 = PhoneForSnapshotTesting(config: ViewImageConfig.iPhone8(.portrait), name: "iPhone8")
  final let iPhoneX = PhoneForSnapshotTesting(config: ViewImageConfig.iPhoneX(.portrait), name: "iPhoneX")
  final let iPhoneXR = PhoneForSnapshotTesting(config: ViewImageConfig.iPhoneXr(.portrait), name: "iPhoneXR")
  final let iPhoneMax = PhoneForSnapshotTesting(config: ViewImageConfig.iPhoneXsMax(.portrait), name: "iPhoneMax")

  final var snapshotDevices: [PhoneForSnapshotTesting] {
    return [iPhoneSe, iPhone8, iPhoneX, iPhoneXR, iPhoneMax]
  }

  override func setUp() {
    super.setUp()
    // If you have ksDiff you can use that to diff your snapshots and see what changed :]
    diffTool = "ksdiff"
  }

  override func tearDown() {
    super.tearDown()
  }
}
