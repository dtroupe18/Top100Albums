//
//  UIUpdatable.swift
//  Top100Albums
//
//  Created by Dave Troupe on 9/29/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Foundation

protocol UIUpdatable: AnyObject {
  func performUIUpdate(using closure: @escaping () -> Void)
}

extension UIUpdatable {
  func performUIUpdate(using closure: @escaping () -> Void) {
    // If we are already on the main thread, execute the closure directly
    if Thread.isMainThread {
      closure()
    } else {
      DispatchQueue.main.async(execute: closure)
    }
  }
}
