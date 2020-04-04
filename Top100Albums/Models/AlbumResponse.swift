//
//  AlbumResponse.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Foundation

// MARK: - AlbumResponse

struct AlbumResponse: Codable {
  let feed: Feed
}

// MARK: - Feed

struct Feed: Codable {
  let results: [Album]

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.results = try container.decode(
      [FailableDecodable<Album>].self,
      forKey: .results
    ).compactMap { $0.optionalType }
  }
}

// MARK: - Result

struct Album: Codable, Hashable {
  let artistName, id, releaseDate, name: String
  let copyright, artistID: String
  let contentAdvisoryRating: String?
  let artistURL: String
  let artworkUrl100: String
  let genres: [Genre]
  let url: String

  enum CodingKeys: String, CodingKey {
    case artistName, id, releaseDate, name, copyright
    case artistID = "artistId"
    case contentAdvisoryRating
    case artistURL = "artistUrl"
    case artworkUrl100, genres, url
  }

  // Note: Hashable requires Equatable as well. Additionally,
  // you want to make sure that if a == b, then a.hashValue == b.hashValue,
  // because different objects can have the same hash, Hashable alone is not
  // enough to tell if two objects are equal.
  //
  // if a.hashValue == b.hashValue, then a may or may not equal b.

  func hash(into hasher: inout Hasher) {
    hasher.combine(artistName)
    hasher.combine(id)
    hasher.combine(releaseDate)
    hasher.combine(name)
    hasher.combine(copyright)
    hasher.combine(artistID)
    hasher.combine(contentAdvisoryRating)
    hasher.combine(artistURL)
    hasher.combine(artworkUrl100)
    hasher.combine(genres)
    hasher.combine(url)
  }

  static func == (lhs: Album, rhs: Album) -> Bool {
    return lhs.artistName == rhs.artistName &&
      lhs.artistName == rhs.artistName &&
      lhs.id == rhs.id &&
      lhs.releaseDate == rhs.releaseDate &&
      lhs.name == rhs.name &&
      lhs.copyright == rhs.copyright &&
      lhs.artistID == rhs.artistID &&
      lhs.contentAdvisoryRating == rhs.contentAdvisoryRating &&
      lhs.artistURL == rhs.artistURL &&
      lhs.artworkUrl100 == rhs.artworkUrl100 &&
      lhs.genres == rhs.genres &&
      lhs.url == rhs.url
  }
}

// MARK: - Genre

struct Genre: Codable, Hashable {
  let genreID, name: String
  let url: String

  enum CodingKeys: String, CodingKey {
    case genreID = "genreId"
    case name, url
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(genreID)
    hasher.combine(name)
    hasher.combine(url)
  }

  static func == (lhs: Genre, rhs: Genre) -> Bool {
    return lhs.genreID == rhs.genreID &&
      lhs.name == rhs.name &&
      lhs.url == rhs.url
  }
}
