//
//  AlbumDetailsTestViewModel.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/3/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit
@testable import Top100Albums

/// Test viewModel for UI snapshot) testing only.
final class AlbumDetailsTestViewModel: AlbumDetailsViewModelProtocol {
  weak var coordinatorDelegate: AlbumDetialsViewModelCoordinatorDelegate?
  private let album: Album

  private let toStringformatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, yyyy"
    return formatter
  }()

  private let toDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  var albumName: String {
    return album.name
  }

  var artist: String {
    return album.artistName
  }

  var genres: [Genre] {
    return album.genres.filter { $0.name.lowercased() != "music" }
  }

  var genreNamesString: String {
    return genres.map { $0.name }.joined(separator: ", ")
  }

  private var releaseDate: Date? {
    return toDateFormatter.date(from: album.releaseDate)
  }

  var releaseDateStr: String {
    guard let date = releaseDate else { return "" }
    return toStringformatter.string(from: date)
  }

  var copyright: String {
    return album.copyright
  }

  var itunesUrl: URL? {
    return URL(string: album.url)
  }

  var imageUrl: URL? {
    // Return nil so the placeholder is used in snapshots.
    return nil
  }

  var placeholder: UIImage? {
    return UIImage(imageName: .albumArtPlaceholder)
  }

  init(album: Album) {
    self.album = album
  }

  func didFinish() {
    coordinatorDelegate?.albumDetialsViewModelDidFinish(self)
  }
}
