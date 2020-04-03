//
//  AnimatedButton.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/2/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

/// Button that animates when highlighted and provides haptic feedback on touchDown events.
class AnimatedButton: UIButton {
  override var isHighlighted: Bool {
    didSet {
      if self.isHighlighted {
        self.animateButtonDown() // in UIButton extension
      } else {
        self.animateButtonUp()
      }
    }
  }
}
