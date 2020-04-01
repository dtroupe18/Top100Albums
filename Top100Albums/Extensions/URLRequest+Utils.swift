//
//  URLRequest+Utils.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Foundation

extension URLRequest {
  var debugString: String {
    var dict = allHTTPHeaderFields ?? [:]
    dict["url"] = url?.absoluteString
    dict["method"] = httpMethod

    return dict.asJsonString
  }
}
