//
//  Volume.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/26.
//

import Foundation

struct Volume: Decodable {
  let id: String
  let info: Info
  
  private enum CodingKeys: String, CodingKey {
    case id
    case info = "volumeInfo"
  }
}

extension Volume {
  static let empty = Volume(id: "", info: .empty)
  
  struct List: Decodable {
    let items: [Volume]?
    let totalItems: Int
  }
}

extension Volume.List {
  static let empty = Volume.List(items: nil, totalItems: 0)
}

extension Volume {
  struct Info: Decodable {
    let title: String
    let subtitle: String?
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let imageLinks: ImageLinks?
  }
}

extension Volume.Info {
  struct ImageLinks: Decodable {
    let thumbnail: String
    let smallThumbnail: String
  }
}

extension Volume.Info {
  static let empty = Volume.Info(
    title: "",
    subtitle: nil,
    authors: nil,
    publisher: nil,
    publishedDate: nil,
    description: nil,
    imageLinks: nil)
  
  var authorsText: String {
    return authors?.joined(separator: ", ") ?? "Unknown Author"
  }
  
  var publishedDateText: String {
    return publishedDate ?? "No Published Date"
  }
  
  var descriptionText: String {
    return description ?? "No Description"
  }
  
  var thumbnailURL: URL? {
    guard let urlString = imageLinks?.thumbnail.replacingOccurrences(of: "http", with: "https") else {
      return nil
    }
    return URL(string: urlString)
  }
  
  var smallThumbnailURL: URL? {
    guard let urlString = imageLinks?.smallThumbnail.replacingOccurrences(of: "http", with: "https") else {
      return nil
    }
    return URL(string: urlString)
  }
}
