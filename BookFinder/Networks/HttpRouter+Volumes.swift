//
//  HttpRouter+Volumes.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/26.
//

import Foundation
import Alamofire

extension HttpRouter {
  enum Volumes {
    case search(text: String, index: Int = 0, counts: Int = 20)
    case detail(id: String)
  }
}

extension HttpRouter.Volumes: HttpRoutable {
  private var endpoint: String { return "volumes" }
  
  var path: String {
    switch self {
    case .search:
      return "/\(endpoint)"
    
    case let .detail(id):
      return "/\(endpoint)/\(id)"
    }
  }
  
  var parameters: Parameters? {
    guard case let .search(text, index, counts) = self else { return nil }
    return Parameters([
      "q": "intitle:\(text)",
      "startIndex": "\(index)",
      "maxResults": "\(counts)"
    ])
  }
}
