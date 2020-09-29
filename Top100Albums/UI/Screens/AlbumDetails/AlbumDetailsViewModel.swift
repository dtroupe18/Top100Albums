//
//  AlbumDetailsViewModel.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/2/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import UIKit

protocol AlbumDetailsViewModelProtocol: AnyObject {
  var coordinatorDelegate: AlbumDetialsViewModelCoordinatorDelegate? { get set }
  var albumName: String { get }
  var artist: String { get }
  var genres: [Genre] { get }
  var genreNamesString: String { get }
  var releaseDateStr: String { get }
  var copyright: String { get }
  var itunesUrl: URL? { get }
  var imageUrl: URL? { get }
  var placeholder: UIImage? { get }

  init(album: Album)

  func didFinish()
}

protocol AlbumDetialsViewModelCoordinatorDelegate: class {
  func albumDetialsViewModelDidFinish(_: AlbumDetailsViewModelProtocol)
}

final class AlbumDetialsViewModel: AlbumDetailsViewModelProtocol {
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
    return URL(string: album.artworkUrl100)
  }

  var placeholder: UIImage? {
    return Image.albumArtPlaceholder.value
  }

  init(album: Album) {
    self.album = album
  }

  func didFinish() {
    coordinatorDelegate?.albumDetialsViewModelDidFinish(self)
  }
}
