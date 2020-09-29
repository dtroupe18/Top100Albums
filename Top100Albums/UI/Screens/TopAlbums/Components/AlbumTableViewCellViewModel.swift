//
//  AlbumTableViewCellViewModel.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

protocol AlbumTableViewCellViewModelProtocol: AnyObject {
  var albumName: String { get }
  var artistName: String { get }
  var artworkUrl: URL? { get }
  var placeholderImage: UIImage? { get }
}

final class AlbumTableViewCellViewModel: AlbumTableViewCellViewModelProtocol {
  private let album: Album

  var albumName: String {
    return album.name
  }

  var artistName: String {
    return album.artistName
  }

  var artworkUrl: URL? {
    return URL(string: album.artworkUrl100)
  }

  var placeholderImage: UIImage? {
    return Image.albumArtPlaceholder.value
  }

  init(album: Album) {
    self.album = album
  }
}
