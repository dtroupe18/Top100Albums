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
  let id: String
  let updated: String
  let results: [Album]

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.updated = try container.decode(String.self, forKey: .updated)

    self.results = try container.decode(
      [FailableDecodable<Album>].self,
      forKey: .results
    ).compactMap { $0.optionalType }
  }
}

// MARK: - Result

struct Album: Codable {
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
}

// MARK: - Genre

struct Genre: Codable {
  let genreID, name: String
  let url: String

  enum CodingKeys: String, CodingKey {
    case genreID = "genreId"
    case name, url
  }
}
