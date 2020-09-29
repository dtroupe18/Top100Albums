//
//  AlbumTableViewCellTestViewModel.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

@testable import Top100Albums
import UIKit

/// Test viewModel for UI snapshot) testing only.
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
    return Image.albumArtPlaceholder.value
  }

  init(album: Album) {
    self.album = album
  }
}
