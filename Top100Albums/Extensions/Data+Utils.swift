//
//  Data+Utils.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Foundation

extension Data {
  var asJsonString: String? {
    if let dict = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] {
      return dict.asJsonString
    }

    return nil
  }
}
