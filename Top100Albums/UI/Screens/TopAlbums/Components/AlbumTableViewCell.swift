//
//  AlbumTableViewCell.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Kingfisher
import SnapKit
import UIKit

final class AlbumTableViewCell: UITableViewCell {
  private let albumImageView: UIImageView = {
    let imgView = UIImageView()
    imgView.contentMode = .scaleAspectFit
    return imgView
  }()

  private let albumTitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.lineBreakMode = .byTruncatingTail
    label.font = UIFont.boldSystemFont(ofSize: 16)
    return label
  }()

  private let artistNameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.lineBreakMode = .byTruncatingTail
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()

  private var imageDownloadTask: DownloadTask?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = UIColor.systemBackground

    contentView.addSubview(albumImageView)
    albumImageView.snp.makeConstraints({ make in
      make.top.equalTo(contentView).offset(8)
      make.height.width.equalTo(50)
      make.left.equalTo(contentView).offset(8)
      make.bottom.equalTo(contentView).offset(-8)
    })

    contentView.addSubview(albumTitleLabel)
    albumTitleLabel.snp.makeConstraints({ make in
      make.top.equalTo(contentView).offset(8)
      make.left.equalTo(albumImageView.snp.right).offset(10)
      make.right.equalTo(contentView).offset(-10)
    })

    contentView.addSubview(artistNameLabel)
    artistNameLabel.snp.makeConstraints({ make in
      make.top.equalTo(albumTitleLabel.snp.bottom).offset(4)
      make.left.right.equalTo(albumTitleLabel)
      make.bottom.equalTo(contentView).offset(-8)
    })
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    imageDownloadTask?.cancel()
    albumImageView.image = nil
    albumTitleLabel.text = nil
    artistNameLabel.text = nil
  }

  public func configureWith(_ viewModel: AlbumTableViewCellViewModelProtocol) {
    imageDownloadTask = albumImageView.kf.setImage(
      with: viewModel.artworkUrl,
      placeholder: viewModel.placeholderImage
    )

    albumTitleLabel.text = viewModel.albumName
    artistNameLabel.text = viewModel.artistName
  }
}
