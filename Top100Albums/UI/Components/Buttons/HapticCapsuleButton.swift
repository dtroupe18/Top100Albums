//
//  HapticCapsuleButton.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/2/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

final class HapticCapsuleButton: AnimatedButton {
  private let selectionFeedbackGenerator = UISelectionFeedbackGenerator()

  override var bounds: CGRect {
    didSet {
      // Make the button a capsule.
      self.layer.cornerRadius = self.bounds.height / 2
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.commonInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.commonInit()
  }

  private func commonInit() {
    addTarget(self, action: #selector(self.sendFeedback), for: .touchDown)
  }

  @objc private func sendFeedback() {
    self.selectionFeedbackGenerator.selectionChanged()
  }
}
