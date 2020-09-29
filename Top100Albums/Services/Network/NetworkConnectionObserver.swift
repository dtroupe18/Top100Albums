//
//  NetworkConnectionObserver.swift
//  Top100Albums
//
//  Created by Dave Troupe on 9/29/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Alamofire
import Foundation
import SystemConfiguration

protocol NetworkStatusUIDelegate: AnyObject {
  func statusJustBecameReachable()
  func statusJustBecameNotReachable()
}

protocol NetworkConnectionObserverProtocol: AnyObject {
  var uiDelegate: NetworkStatusUIDelegate? { get set }
  var currentStatus: NetworkReachabilityManager.NetworkReachabilityStatus { get }
  var isConnectedToInternet: Bool { get }

  init(reachabilityManager: NetworkReachabilityManager?)
}

final class NetworkConnectionObserver: NetworkConnectionObserverProtocol {
  weak var uiDelegate: NetworkStatusUIDelegate?

  private(set) var currentStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown
  private let reachabilityManager: NetworkReachabilityManager?

  init(reachabilityManager: NetworkReachabilityManager? = NetworkReachabilityManager()) {
    self.reachabilityManager = reachabilityManager
    startNetworkReachabilityObserver()
  }

  var isConnectedToInternet: Bool {
    var zeroAddress = sockaddr_in(
      sin_len: 0,
      sin_family: 0,
      sin_port: 0,
      sin_addr: in_addr(s_addr: 0),
      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0)
    )
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)

    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
        SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
      }
    }

    var flags = SCNetworkReachabilityFlags(rawValue: 0)
    // swiftlint:disable:next force_unwrapping
    if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
      return false
    }

    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
  }

  func startNetworkReachabilityObserver() {
    reachabilityManager?.startListening(onUpdatePerforming: { [weak self] status in
      guard let self = self else { return }

      switch status {
      case .unknown:
        Logger.logDebug("\(String(describing: self)) it is unknown whether the network is reachable.")
      case .notReachable:
        if self.currentStatus == .reachable(.ethernetOrWiFi) || self.currentStatus == .reachable(.ethernetOrWiFi) {
          self.uiDelegate?.statusJustBecameNotReachable()
        }

        Logger.logDebug("\(String(describing: self)) the network is not reachable.")
      case .reachable:
        if self.currentStatus == .notReachable {
          self.uiDelegate?.statusJustBecameReachable()
        }

        Logger.logDebug("\(String(describing: self)) the network is reachable.")
      }

      self.currentStatus = status
    })
  }
}
