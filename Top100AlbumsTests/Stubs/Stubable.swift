//
//  StubLoading.swift
//  Top100AlbumsTests
//
//  Created by Dave Troupe on 4/2/20.
//  Copyright © 2020 DavidTroupe. All rights reserved.
//

import Foundation
@testable import Top100Albums

enum FileName: String {
  // Stub with all 100 albums. We use this to test our `ApiClient`.
  case fullStub = "FullAlbumStub"

  // Stub with 3 albums, one is missing Genres, and the other is missing
  // a url. This is used to test that `FailableDecodable` works.
  case missingAlbumDataStub = "MissingAlbumDataStub"

  // Stub with only one album so we can test that all values are correctly decoded.
  case oneAlbumStub = "OneAlbumStub"
}

enum FileType: String {
  case json = ".json"
}

protocol Stubable: AnyObject {}

extension Stubable {
  private func makeFileMissingError(filename: FileName) -> Error {
    return NSError(
      domain: "",
      code: 404,
      userInfo: [NSLocalizedDescriptionKey: "File \(filename.rawValue) not found in test bundle"]
    )
  }

  public func loadDataFrom(filename: FileName, fileType: FileType = .json) throws -> Data {
    let testBundle = Bundle(for: type(of: self))

    guard let path = testBundle.path(forResource: filename.rawValue, ofType: fileType.rawValue) else {
      throw (self.makeFileMissingError(filename: filename))
    }

    return try Data(contentsOf: URL(fileURLWithPath: path))
  }

  func parseDataFrom<T: Decodable>(
    decodableType: T.Type,
    filename: FileName,
    fileType: FileType,
    callingClass: AnyObject
  ) throws -> T {
    do {
      let data = try loadDataFrom(filename: filename, fileType: fileType)
      return try JSONDecoder().decode(decodableType, from: data)
    } catch let err {
      throw (err)
    }
  }

  func makeSingleAlbum(callingClass: AnyObject) throws -> Album? {
    return try parseDataFrom(
      decodableType: AlbumResponse.self,
      filename: .oneAlbumStub,
      fileType: .json,
      callingClass: callingClass
    ).feed.results.first
  }

  func make100Albums(callingClass: AnyObject) throws -> [Album] {
    return try parseDataFrom(
      decodableType: AlbumResponse.self,
      filename: .fullStub,
      fileType: .json,
      callingClass: callingClass
    ).feed.results
  }
}
