//
//  AlbumTableViewCellViewModel.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

protocol AlbumTableViewCellViewModelProtocol: AnyObject {
  var album: Album { get }
  var albumName: String { get }
  var artistName: String { get }
  var artworkUrl: URL? { get }
  var placeholderImage: UIImage? { get }

  init(album: Album)
}

final class AlbumTableViewCellViewModel: AlbumTableViewCellViewModelProtocol {
  let album: Album

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
    return UIImage(imageName: .albumArtPlaceholder)
  }

  init(album: Album) {
    self.album = album
  }
}
