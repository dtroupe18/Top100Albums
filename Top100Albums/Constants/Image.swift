//
//  ImageName.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

enum Image: CaseIterable {
  case albumArtPlaceholder
  case chevronLeft // SFSymbol

  var filename: String {
    switch self {
    case .albumArtPlaceholder: return "AlbumArtPlaceholder"
    case .chevronLeft: return "chevron.left"
    }
  }

  /// UIImage value for `Image` case.
  var value: UIImage? {
    switch self {
    case .chevronLeft:
      return UIImage(systemName: filename)

    default:
      return UIImage(named: filename)
    }
  }
}
