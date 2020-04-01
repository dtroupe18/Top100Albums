//
//  NetworkError.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Foundation

/// Errors returned from ApiClient.
enum NetworkError: Swift.Error {
  case noData
  case decodeFailed
  case urlCreation

  var localizedDescription: String {
    switch self {
    case .noData:
      return "No response from server please try again."
    case .decodeFailed:
      return "The server response is missing data. Please try again."
    case .urlCreation:
      return "The was an issue completing your request. Please try again."
    }
  }
}
