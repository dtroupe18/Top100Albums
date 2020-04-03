//
//  SFSymbolName.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/2/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Foundation

enum SFSymbolName: CustomStringConvertible, CaseIterable {
  case chevronLeft

  var description: String {
    switch self {
    case .chevronLeft: return "chevron.left"
    }
  }
}
