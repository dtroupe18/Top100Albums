//
//  TopAlbumsViewController.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit
import SnapKit

final class TopAlbumsViewController: BaseViewController {
  private let viewModel: TopAlbumsViewModelProtocol

  init(viewModel: TopAlbumsViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.viewModel.viewDelegate = self
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red

    self.viewModel.fetchTopAlbums()
  }
}

extension TopAlbumsViewController: TopAlbumsViewModelViewDelegate {
  func topAlbumsViewModel(_ viewModel: TopAlbumsViewModelProtocol, gotError error: Error) {
    DispatchQueue.main.async {
      self.showErrorAlert(msg: error.localizedDescription)
    }
  }

  func topAlbumsViewModelGotResults(_ viewModel: TopAlbumsViewModelProtocol) {
    // qwe
  }
}
