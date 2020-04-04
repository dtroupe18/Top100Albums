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

  // MARK: UITableViewDiffableDataSource

  // We have to use Album in the diffable data source because it requires that
  // the provided types are Hashable. We could make the cellViewModel Hashable, but
  // then our use of protocol conforming has associated type issues. This occurs because
  // Hashable requires Equatable as well and `==` requires type `Self`.
  //
  // However, as you can see below we diff on the model, but we still configure
  // the cell with a viewModel so we don't break MVVM.
  //
  // Additional note: I am returning an optional UITableViewCell here (to avoid force
  // unwrapping, but if the cell was `nil` this would still crash.
  private lazy var dataSource: UITableViewDiffableDataSource<Int, Album> = {
    return UITableViewDiffableDataSource(
      tableView: tableView,
      cellProvider: {  tableView, indexPath, _ in
        let cell = tableView.dequeueReusableCell(
          withIdentifier: self.cellIdentifier,
          for: indexPath
          ) as? AlbumTableViewCell

        cell?.accessoryType = .disclosureIndicator
        cell?.configureWith(self.viewModel.cellViewModels[indexPath.row])
        return cell
    })
  }()

  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.separatorColor = UIColor.systemGray
    tableView.estimatedRowHeight = 66.0
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorInset = .zero
    tableView.showsVerticalScrollIndicator = false
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
    tableView.delegate = self
    tableView.dataSource = self.dataSource
    tableView.prefetchDataSource = self.viewModel
    tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)

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

// MARK: TopAlbumsViewModelViewDelegate

extension TopAlbumsViewController: TopAlbumsViewModelViewDelegate {
  func topAlbumsViewModel(_ viewModel: TopAlbumsViewModelProtocol, gotError error: Error) {
    performUIUpdate {
      self.hideActivityIndicator()
      self.showErrorAlert(msg: error.localizedDescription)
    }
  }

  func topAlbumsViewModelGotResults(_ viewModel: TopAlbumsViewModelProtocol) {
    performUIUpdate {
      self.hideActivityIndicator()

      // MARK: UITableViewDiffableDataSource

      var snapshot = NSDiffableDataSourceSnapshot<Int, Album>()
      snapshot.appendSections([0]) // Add a section - this is required.
      snapshot.appendItems(viewModel.cellViewModels.map { $0.album }) // Add all the albums to that section.
      self.dataSource.apply(snapshot, animatingDifferences: true, completion: nil) // Add this data to the view.
    }
  }
}
