//
//  UIImage+Utils.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/2/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

extension UIImage {
  convenience init?(sfSymbolName: SFSymbolName) {
    self.init(systemName: sfSymbolName.description)
  }
}
