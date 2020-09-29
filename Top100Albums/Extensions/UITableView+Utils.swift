//
//  UITableView.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/7/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

extension UITableView {
  func reloadWithAnimation() {
    self.reloadData()

    let tableViewHeight = self.bounds.size.height
    let cells = self.visibleCells

    for (index, cell) in cells.enumerated() {
      cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)

      UIView.animate(
        withDuration: 1.5,
        delay: 0.05 * Double(index),
        usingSpringWithDamping: 0.75,
        initialSpringVelocity: 0,
        options: .curveEaseInOut, animations: {
          cell.transform = CGAffineTransform.identity
        }, completion: nil)
    }
  }
}
