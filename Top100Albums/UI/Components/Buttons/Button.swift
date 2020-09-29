//
//  Button.swift
//  Top100Albums
//
//  Created by Dave Troupe on 9/29/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

final class Button: UIButton {
  private lazy var selectionFeedbackGenerator: UISelectionFeedbackGenerator = {
    UISelectionFeedbackGenerator()
  }()

  override var bounds: CGRect {
    didSet {
      guard isCapsule else { return }
      self.layer.cornerRadius = self.bounds.height / 2
    }
  }

  override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        animateButtonDown()
      } else {
        animateButtonUp()
      }
    }
  }

  public var isCapsule: Bool = false {
    didSet {
      setNeedsDisplay()
    }
  }

  /// Causes the button to shrink when pressed and
  /// expand once released.
  /// - Default`false`
  public var shouldAnimateOnPress: Bool = false

  /// Causes the button to send haptic selection feedback
  /// on `touchUpInside` events.
  /// - Default: `false`
  public var shouldSendHapticFeedback: Bool = false

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  /// Disables userInteraction and updates the bg & text color.
  public func styleForDisabled(bgColor: UIColor, textColor: UIColor) {
    isUserInteractionEnabled = false
    backgroundColor = bgColor
    setTitleColor(textColor, for: .normal)
  }

  /// Enables userInteraction and updates the bg & text color.
  public func styleForEnabled(bgColor: UIColor, textColor: UIColor) {
    isUserInteractionEnabled = true
    backgroundColor = bgColor
    setTitleColor(textColor, for: .normal)
  }

  private func commonInit() {
    addTarget(self, action: #selector(sendFeedback), for: .touchUpInside)
  }

  @objc private func sendFeedback() {
    guard shouldSendHapticFeedback else { return }
    selectionFeedbackGenerator.selectionChanged()
  }

  private func animateButtonDown() {
    guard shouldAnimateOnPress else { return }

    UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseIn], animations: {
      self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }, completion: nil)
  }

  private func animateButtonUp() {
    guard shouldAnimateOnPress else { return }

    UIView.animate(withDuration: 0.1, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: {
      self.transform = CGAffineTransform.identity
    }, completion: nil)
  }
}
