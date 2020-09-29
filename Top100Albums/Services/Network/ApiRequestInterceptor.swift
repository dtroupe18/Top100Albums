//
//  ApiRequestInterceptor.swift
//  Top100Albums
//
//  Created by Dave Troupe on 9/29/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Alamofire
import Foundation

protocol RequestInterceptorProtocol: RequestInterceptor {
  var urlsToRetry: Set<URL?> { get }
}

final class ApiRequestInterceptor: RequestInterceptorProtocol {
  private(set) lazy var urlsToRetry: Set<URL?> = [
    ApiRoute.topAlbums.url
  ]

  public func adapt(
    _ urlRequest: URLRequest,
    for _: Session,
    completion: @escaping (Result<URLRequest, Error>) -> Void
  ) {
    completion(.success(urlRequest))
  }

  public func retry(
    _ request: Request,
    for _: Session,
    dueTo error: Error,
    completion: @escaping (RetryResult) -> Void
  ) {
    let url = request.request?.url
    Logger.logError(error, additionalInfo: ["url": String(describing: url)])

    if let response = request.task?.response as? HTTPURLResponse, request.retryCount < 2 {
      // Always retry for connection lost.
      if (error as NSError).code == NSURLErrorNetworkConnectionLost {
        // Ref - https://stackoverflow.com/a/25996971
        Logger.logDebug("Retying request because of NSURLErrorNetworkConnectionLost Error")
        completion(.retryWithDelay(2.0))
        return
      }

      // Always retry for timeout.
      if (error as NSError).code == NSURLErrorTimedOut {
        Logger.logDebug("Retying request because of NSURLErrorTimedOut Error")
        completion(.retryWithDelay(2.0))
        return
      }

      // Check if this url should be retried.
      if !urlsToRetry.contains(url) {
        Logger.logDebug("\(String(describing: self)) not retrying request for url \(String(describing: url))")
        completion(.doNotRetry)
        return
      }

      // Check if we should retry for this status code.
      if !(200 ... 299 ~= response.statusCode) {
        Logger.logDebug("\(String(describing: self)) Retrying request for the \(request.retryCount) time")
        completion(.retryWithDelay(2.0))
      } else {
        completion(.doNotRetry)
      }
    } else {
      // Don't retry we either don't have a response or we have already retried twice.
      completion(.doNotRetry)
    }
  }
}
