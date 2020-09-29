//
//  ApiClient.swift
//  Top100Albums
//
//  Created by Dave Troupe on 4/1/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Alamofire
import Foundation
import PromiseKit

typealias NetworkPromise<T: Decodable> = Promise<T>

protocol ApiClientProtocol: AnyObject {
  var session: Session { get }
  var networkConnectionObserver: NetworkConnectionObserverProtocol { get }
  var interceptor: RequestInterceptorProtocol { get }

  func makeRequest<Type: Decodable, Parameters: Encodable>(
    method: HTTPMethod,
    route: ApiRoute,
    paramObject: Parameters
  ) -> NetworkPromise<Type>
}

final class ApiClient: ApiClientProtocol {
  let session: Session
  let interceptor: RequestInterceptorProtocol
  let networkConnectionObserver: NetworkConnectionObserverProtocol

  private var timezoneOffset: String {
    let seconds = TimeZone.current.secondsFromGMT()
    let hours = seconds / 3600
    let minutes = abs(seconds / 60) % 60
    return String(format: "%+.2d:%.2d", hours, minutes)
  }

  init(session: Session, networkConnectionObserver: NetworkConnectionObserverProtocol) {
    guard let inter = session.interceptor as? RequestInterceptorProtocol else {
      fatalError("Intercepter does not conform to RequestInterceptorProtocol")
    }

    self.session = session
    self.interceptor = inter
    self.networkConnectionObserver = networkConnectionObserver
  }

  /// Used to make all requests.
  /// All errors are logged in the API client and do not require additional logging.
  func makeRequest<Type, Parameters>(
    method: HTTPMethod,
    route: ApiRoute,
    paramObject: Parameters
  ) -> NetworkPromise<Type> where Type: Decodable, Parameters: Encodable {
    return Promise { seal in
      let urlStr = route.rawValue
      Logger.logDebug(urlStr)

      let queue = DispatchQueue(label: "NetworkBackground", qos: .background, attributes: .concurrent)

      session.request(urlStr, method: method, parameters: paramObject)
        .validate().responseData(queue: queue) { response in
          switch response.result {
          case let .success(data):
            Logger.logJson(data)

            do {
              let decodedData = try JSONDecoder().decode(Type.self, from: data)
              seal.fulfill(decodedData)
            } catch let err {
              Logger.logError(err, additionalInfo: [
                "debug_description": response.debugDescription,
                "url": urlStr,
                "message": "Error decoding \(Type.self) from data."
              ])

              seal.reject(err)
            }
          case let .failure(err):
            Logger.logError(err, additionalInfo: [
              "debug_description": response.debugDescription,
              "url": urlStr
            ])

            seal.reject(err)
          }
        }.cURLDescription { description in
          // Print curl to console.
          Logger.logDebug(description)
        }
    }
  }
}
