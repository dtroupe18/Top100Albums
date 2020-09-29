//
//  AlbumDetailsViewController.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/2/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

final class AlbumDetailsViewController: BaseViewController {
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  private let verticalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillProportionally
    stackView.spacing = 4
    return stackView
  }()

  private lazy var itunesButton: HapticCapsuleButton = {
    let button = HapticCapsuleButton()
    button.backgroundColor = UIColor.systemBlue
    button.setTitle("View in Apple Music", for: .normal)
    button.addTarget(self, action: #selector(self.itunesButtonPressed), for: .touchUpInside)
    return button
  }()

  private lazy var backButton: AnimatedButton = {
    let button = AnimatedButton(type: .custom)
    button.addTarget(self, action: #selector(self.backPressed), for: .touchUpInside)
    button.contentHorizontalAlignment = .left
    return button
  }()

  private let viewModel: AlbumDetailsViewModelProtocol

  init(viewModel: AlbumDetailsViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.systemBackground
    title = viewModel.albumName

    addBackButton()
    addImageView()
    addButton()
    addStackView()
  }

  private func addBackButton() {
    let backArrowImg = Image.chevronLeft.value
    backButton.setImage(backArrowImg, for: .normal)

    let barButton = UIBarButtonItem(customView: backButton)
    barButton.customView?.translatesAutoresizingMaskIntoConstraints = false
    barButton.customView?.widthAnchor.constraint(equalToConstant: 48).isActive = true
    barButton.customView?.heightAnchor.constraint(equalToConstant: 44).isActive = true
    navigationItem.leftBarButtonItem = barButton
  }

  private func addImageView() {
    imageView.kf.setImage(with: viewModel.imageUrl, placeholder: viewModel.placeholder)
    view.addSubview(imageView)
    imageView.snp.makeConstraints({ make in
      make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
      make.centerX.equalTo(view)
      make.width.height.equalTo(200)
    })
  }

  private func addButton() {
    view.addSubview(itunesButton)
    itunesButton.snp.makeConstraints({ make in
      make.left.equalTo(view).offset(20)
      make.right.equalTo(view).offset(-20)
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
    })
  }

  private func addStackView() {
    let albumLabel = makeLabel(descriptionText: "Album Title", valueText: viewModel.albumName)
    let artistLabel = makeLabel(descriptionText: "Artist", valueText: viewModel.artist)

    let genreDescription = viewModel.genres.count == 1 ? "Genre" : "Genres"
    let genreLabel = makeLabel(descriptionText: genreDescription, valueText: viewModel.genreNamesString)

    let releaseDateLabel = makeLabel(descriptionText: "Release Date", valueText: viewModel.releaseDateStr)
    let copyrightLabel = makeLabel(descriptionText: "Copyright", valueText: viewModel.copyright)

    verticalStackView.addArrangedSubviews([albumLabel, artistLabel, genreLabel, releaseDateLabel, copyrightLabel])

    view.addSubview(verticalStackView)
    verticalStackView.snp.makeConstraints({ make in
      make.top.equalTo(imageView.snp.bottom).offset(16)
      make.left.right.equalTo(imageView)
      make.bottom.lessThanOrEqualTo(itunesButton).offset(-16)
    })
  }

  @objc private func itunesButtonPressed() {
    guard let url = viewModel.itunesUrl else { return }

    guard UIApplication.shared.canOpenURL(url) else {
      showErrorAlert(title: "Error", msg: "Cannot open url")
      return
    }

    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }

  @objc private func backPressed() {
    self.viewModel.didFinish()
  }

  private func makeLabel(descriptionText: String, valueText: String) -> UILabel {
    let textToBold = "\(descriptionText):  "
    let boldAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
    let attributedString = NSMutableAttributedString(string: textToBold, attributes: boldAttributes)

    let normalAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
    attributedString.append(NSMutableAttributedString(string: valueText, attributes: normalAttributes))

    let label = UILabel()
    label.attributedText = attributedString
    label.numberOfLines = 0
    label.lineBreakMode = .byTruncatingTail
    return label
  }
}
