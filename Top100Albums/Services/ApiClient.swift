//
//  ApiClient.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Foundation

typealias ErrorCallback = (Error) -> Void
typealias DecodableCallback<T: Decodable> = (T) -> Void

protocol ApiClientProtocol: AnyObject {
  init(urlSession: URLSession)

  // qwe get albums
}

final class ApiClient: ApiClientProtocol {
  private let urlSession: URLSession

  init(urlSession: URLSession) {
    self.urlSession = urlSession
  }

  private func createUrlRequest(for url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.setValue("Content-type", forHTTPHeaderField: "application/json")

    // Add the other headers you need like authorization
    return request
  }

  /**
  Performs a URL request and returns the `DecodableType` or an error.
  - parameter request: URLRequest to perform.
  - parameter decodableType: Any Type that conforms to Decodable.
  - parameter onSuccess: DecodableCallback = (Decodable) -> Void
  - parameter onError: ErrorCallback = (Error) -> Void
  */
  public func makeRequest<T: Decodable>(
    request: URLRequest,
    decodableType: T.Type,
    onSuccess: DecodableCallback<T>?,
    onError: ErrorCallback?
  ) {

    let task = self.urlSession.dataTask(with: request) { [weak self] data, response, error in
      if let err = error {
        DispatchQueue.main.async {
          onError?(err)
        }
        return
      }

      guard let data = data else {
        DispatchQueue.main.async {
          onError?(NetworkError.noData)
        }
        return
      }

#if DEBUG
      self?.logJson(data)
#endif

      do {
        // Decoding on a background thread.
        let decodedType = try JSONDecoder().decode(decodableType, from: data)
        DispatchQueue.main.async {
          onSuccess?(decodedType)
        }
      } catch let err {
        DispatchQueue.main.async {
          onError?(err)
        }
      }
    }
    task.resume()
  }

//  public func getRockets(onSuccess: DecodableCallback<RocketResponse>?, onError: ErrorCallback?) {
//    let url = ApiRoute.rockets.url
//    let request = URLRequest(url: url)
//    self.makeRequest(
//      request: request,
//      decodableType: RocketResponse.self,
//      onSuccess: onSuccess,
//      onError: onError
//    )
//  }
}

#if DEBUG
extension ApiClient {
  private func logJson(_ data: Data) {
    if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
      let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
        print(String(decoding: jsonData, as: UTF8.self))
    } else {
        print("json data malformed")
    }
  }
}
#endif
