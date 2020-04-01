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
  public final func showErrorAlert(title: String = "Error", msg: String) {
    let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))

    present(alertController, animated: true, completion: nil)
  }
}
