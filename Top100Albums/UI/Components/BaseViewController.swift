//
//  BaseViewController.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

/// Parent class for all UIViewControllers.
class BaseViewController: UIViewController {
  private lazy var activityIndicator = ActivityIndicatorView()

  public final func showErrorAlert(title: String = "Error", msg: String) {
    let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))

    present(alertController, animated: true, completion: nil)
  }

  public func showActivityIndicator(disableUserInteraction: Bool = true) {
    // Prevent multiple activity indicators from being added to the view.
    guard !view.subviews.contains(activityIndicator) else { return }

    view.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { make in
      make.height.width.equalTo(60)
      make.center.equalTo(view)
    }

    activityIndicator.startAnimating()
    activityIndicator.isUserInteractionEnabled = false
    view.isUserInteractionEnabled = !disableUserInteraction
  }

  public func hideActivityIndicator() {
    view.isUserInteractionEnabled = true

    if activityIndicator.superview != nil {
      activityIndicator.removeFromSuperview()
    }
  }

  // Function to help reduce test flakiness. Since tests run on the main thread
  // the async dispatch can cause intermitent issues.
  public func performUIUpdate(using closure: @escaping () -> Void) {
    // If we are already on the main thread, execute the closure directly.
    if Thread.isMainThread {
      closure()
    } else {
      DispatchQueue.main.async(execute: closure)
    }
  }
}
