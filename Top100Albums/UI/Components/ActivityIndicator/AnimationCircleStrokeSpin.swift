//
//  AnimationCircleStrokeSpin.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/2/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

final class AnimationCircleStrokeSpin {
  private func layerWith(size: CGSize, color: UIColor) -> CALayer {
    let layer: CAShapeLayer = CAShapeLayer()
    let path: UIBezierPath = UIBezierPath()

    path.addArc(
      withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
      radius: size.width / 2,
      startAngle: -(.pi / 2),
      endAngle: .pi + .pi / 2,
      clockwise: true
    )

    layer.fillColor = nil
    layer.strokeColor = color.cgColor
    layer.lineWidth = 3

    layer.backgroundColor = nil
    layer.path = path.cgPath
    layer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

    return layer
  }

  func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor) {
    let beginTime: Double = 0.5
    let strokeStartDuration: Double = 1.2
    let strokeEndDuration: Double = 0.7

    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
    rotationAnimation.byValue = Float.pi * 2
    rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)

    let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
    strokeEndAnimation.duration = strokeEndDuration
    strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
    strokeEndAnimation.fromValue = 0
    strokeEndAnimation.toValue = 1

    let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
    strokeStartAnimation.duration = strokeStartDuration
    strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
    strokeStartAnimation.fromValue = 0
    strokeStartAnimation.toValue = 1
    strokeStartAnimation.beginTime = beginTime

    let groupAnimation = CAAnimationGroup()
    groupAnimation.animations = [rotationAnimation, strokeEndAnimation, strokeStartAnimation]
    groupAnimation.duration = strokeStartDuration + beginTime
    groupAnimation.repeatCount = .infinity
    groupAnimation.isRemovedOnCompletion = false
    groupAnimation.fillMode = .forwards

    let circle = self.layerWith(size: size, color: color)
    let frame = CGRect(
      x: (layer.bounds.width - size.width) / 2,
      y: (layer.bounds.height - size.height) / 2,
      width: size.width,
      height: size.height
    )

    circle.frame = frame
    circle.add(groupAnimation, forKey: "animation")
    layer.addSublayer(circle)
  }
}
