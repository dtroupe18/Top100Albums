//
//  ActivityIndicatorView.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/2/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

final class ActivityIndicatorView: UIView {
  private(set) var isAnimating: Bool = false

  public override var intrinsicContentSize: CGSize {
    return CGSize(width: self.bounds.width, height: self.bounds.height)
  }

  public override var bounds: CGRect {
    didSet {
      // setup the animation again for the new bounds
      if oldValue != self.bounds, self.isAnimating {
        self.setUpAnimation()
      }
    }
  }

  private let padding: CGFloat = 8.0

  public init() {
    super.init(frame: .zero)
    isHidden = true
    isUserInteractionEnabled = false
    self.setupViews()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    backgroundColor = UIColor.systemGray
    clipsToBounds = true
    layer.cornerRadius = 8
  }

  public final func startAnimating() {
    guard !self.isAnimating else {
      return
    }

    isHidden = false
    self.isAnimating = true
    layer.speed = 1
    self.setUpAnimation()
  }

  public final func stopAnimating() {
    guard self.isAnimating else {
      return
    }

    isHidden = true
    self.isAnimating = false
    layer.sublayers?.removeAll()
  }

  private final func setUpAnimation() {
    let animation = AnimationCircleStrokeSpin()
    let insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    var animationRect = frame.inset(by: insets)
    let minEdge = min(animationRect.width, animationRect.height)

    layer.sublayers = nil
    animationRect.size = CGSize(width: minEdge, height: minEdge)
    animation.setUpAnimation(in: layer, size: animationRect.size, color: UIColor.systemBlue)
  }
}
