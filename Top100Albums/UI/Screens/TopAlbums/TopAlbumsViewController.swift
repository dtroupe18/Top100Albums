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
  private let cellIdentifier: String = "Cell"
  private let viewModel: TopAlbumsViewModelProtocol

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.separatorColor = UIColor.systemGray
    tableView.estimatedRowHeight = 66.0
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorInset = .zero
    tableView.showsVerticalScrollIndicator = false
    tableView.delegate = self
    tableView.dataSource = self
    tableView.prefetchDataSource = self.viewModel
    tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
    return tableView
  }()

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

    navigationController?.navigationBar.barTintColor = UIColor.systemGray5
    navigationController?.navigationBar.titleTextAttributes =
      [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
    title = "Top 100 Albums"
    view.backgroundColor = UIColor.systemBackground

    self.addTableView()
    self.showActivityIndicator()
    self.viewModel.fetchTopAlbums()
  }

  private func addTableView() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints({ make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.left.right.equalTo(view)
      make.bottom.equalTo(view.safeAreaLayoutGuide)
    })
  }
}

// MARK: UITableViewDelegate

extension TopAlbumsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.userDidSelectAlbum(indexPath)
    tableView.deselectRow(at: indexPath, animated: true)
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 66.0
  }
}

// MARK: UITableViewDataSource

extension TopAlbumsViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: self.cellIdentifier,
      for: indexPath) as? AlbumTableViewCell else {
        return UITableViewCell()
    }

    cell.accessoryType = .disclosureIndicator
    cell.configureWith(viewModel.cellViewModels[indexPath.row])
    return cell
  }
}

// MARK: TopAlbumsViewModelViewDelegate

extension TopAlbumsViewController: TopAlbumsViewModelViewDelegate {
  func topAlbumsViewModel(_ viewModel: TopAlbumsViewModelProtocol, gotError error: Error) {
    DispatchQueue.main.async {
      self.hideActivityIndicator()
      self.showErrorAlert(msg: error.localizedDescription)
    }
  }

  func topAlbumsViewModelGotResults(_ viewModel: TopAlbumsViewModelProtocol) {
    DispatchQueue.main.async {
      self.hideActivityIndicator()
      self.tableView.reloadData()
    }
  }
}
