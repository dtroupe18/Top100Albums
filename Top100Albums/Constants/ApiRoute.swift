//
//  ApiRoute.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Foundation

enum ApiRoute: String {
  // Normally you would paginate this call instead of requesting all 100 values at once. However, it doesn't
  // seem like this feed always for pagination.
  case topAlbums = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json"

  var url: URL? {
    return URL(string: self.rawValue)
  }
}
