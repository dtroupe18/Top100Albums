//
//  UIStackView+Utils.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

extension UIStackView {
  func addArrangedSubviews(_ views: [UIView]) {
    for view in views {
      addArrangedSubview(view)
    }
  }
}
