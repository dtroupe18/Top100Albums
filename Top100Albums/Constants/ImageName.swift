//
//  ImageName.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Foundation

enum ImageName: CustomStringConvertible, CaseIterable {
  case albumArtPlaceholder

  var description: String {
    switch self {
    case .albumArtPlaceholder: return "AlbumArtPlaceholder"
    }
  }
}
