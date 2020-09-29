//
//  FailableDecodable.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Foundation

/**
 Use this when decoding an array of a Type so that if one
 element in the array cannot be decoded the entire decode doesn't fail. Just that
 element fails.
 */
struct FailableDecodable<T: Decodable>: Decodable {
  let optionalType: T?

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.optionalType = try? container.decode(T.self)
  }
}
