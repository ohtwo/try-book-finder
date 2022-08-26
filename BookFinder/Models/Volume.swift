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
  struct List: Decodable {
    let kind: String
    let items: [Volume]
    let totalItems: Int
  }
}

extension Volume {
  struct Info: Decodable {
    let title: String
    let subtitle: String?
    let authors: [String]?
    let publisher: String?
    let publishedDate: String
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
