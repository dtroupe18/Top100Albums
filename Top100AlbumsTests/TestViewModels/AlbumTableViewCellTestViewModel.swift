//
//  AlbumTableViewCellTestViewModel.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit
@testable import Top100Albums

final class AlbumTableViewCellTestViewModel: AlbumTableViewCellViewModelProtocol {
  private let album: Album

  var albumName: String {
    return album.name
  }

  var artistName: String {
    return album.artistName
  }

  var artworkUrl: URL? {
    // Return nil so the placeholder is used in snapshot tests.
    return nil
  }

  var placeholderImage: UIImage? {
    return UIImage(imageName: .albumArtPlaceholder)
  }

  init(album: Album) {
    self.album = album
  }
}