//
//  UIButton+Utils.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/2/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

extension UIButton {
  func animateButtonDown() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseIn], animations: {
      self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }, completion: nil)
  }

  func animateButtonUp() {
    UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: {
      self.transform = CGAffineTransform.identity
    }, completion: nil)
  }
}
