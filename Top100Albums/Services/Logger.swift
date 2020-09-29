//
//  Logger.swift
//  Top100Albums
//
//  Created by Dave Troupe on 9/29/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import CocoaLumberjack
import DeviceKit
import Foundation

protocol LoggerProtocol: AnyObject {
  func getLogs() -> [String]
}

final class Logger: LoggerProtocol {
  private static let fileLogger: DDFileLogger = {
    let logger = DDFileLogger()
    logger.rollingFrequency = 60 * 60 * 24 // 24 hours.
    logger.logFileManager.maximumNumberOfLogFiles = 7
    return logger
  }()

  init() {
    DDLog.add(DDOSLogger.sharedInstance, with: DDLogLevel.debug)
    DDLog.add(Logger.fileLogger, with: DDLogLevel.debug)
  }

  public func getLogs() -> [String] {
    let logFilePaths = Logger.fileLogger.logFileManager.sortedLogFilePaths
    var logs: [String] = []

    for logFilePath in logFilePaths {
      let fileURL = NSURL(fileURLWithPath: logFilePath)
      if let logFileData = try? NSData(contentsOf: fileURL as URL, options: NSData.ReadingOptions.mappedIfSafe),
        let logLine = String(data: logFileData as Data, encoding: .utf8) {
        // Write a line so we can clearly see that a new file is starting
        logs.append("\n\n\nStarting new log file \(logFilePath)\n\n\n")
        logs += logLine.components(separatedBy: "\n")
      }
    }

    return logs
  }
}

// MARK: Static Logging

extension Logger {
  /// Logs an error in the console only.
  /// - warning: If you want this error sent to Sentry you should log it in AnalyticsService!
  public static func logErrorToConsoleOnly(
    _ error: Error,
    additionalInfo: [String: Any] = [:],
    filename: String = #file,
    line: Int = #line,
    funcName: String = #function
  ) {
    DDLogError("🚨 ERROR: \(sourceFileName(filePath: filename))] line: \(line) \(funcName) -> \(error.localizedDescription) \(additionalInfo)")
  }

  public static func logDebug(
    _ object: Any,
    filename: String = #file,
    line: Int = #line,
    funcName: String = #function
  ) {
    DDLogDebug("🕵: \(sourceFileName(filePath: filename))] line: \(line) \(funcName) -> \(object)")
  }

  public static func logJson(_ data: Data, msg: String? = nil) {
    guard let json = data.asJsonString else {
      DDLogDebug("Data could not be converted into JSON")
      return
    }

    if let message = msg {
      if Device.current.isSimulator {
        print("\(message)\n\(json)")
      } else {
        DDLogDebug("\(message)\n\(json)")
      }
    } else {
      if Device.current.isSimulator {
        print(json)
      } else {
        DDLogDebug(json)
      }
    }
  }

  /// Logs an error to Sentry and the console.
  public static func logError(
    _ error: Error,
    additionalInfo: [String: Any] = [:],
    filename: String = #file,
    line: Int = #line,
    funcName: String = #function
  ) {
    logErrorToConsoleOnly(
      error,
      additionalInfo: additionalInfo,
      filename: filename,
      line: line,
      funcName: funcName
    )

    // FIXME: Log to analytics service.
  }

  private static func sourceFileName(filePath: String) -> String {
    let components = filePath.components(separatedBy: "/")
    return components.last ?? ""
  }
}
