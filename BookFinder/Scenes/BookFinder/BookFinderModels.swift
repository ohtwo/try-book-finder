//
//  BookFinderModels.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/29.
//

import Foundation

typealias Request = ListBooks.FetchBooks.Request
typealias Response = ListBooks.FetchBooks.Response
typealias ViewModel = ListBooks.FetchBooks.ViewModel

enum ListBooks {
  enum FetchBooks {
    struct Request {
      let searchText: String
    }
    
    struct Response {
      enum Item {
        case result(Volume)
        case loading(Volume)
        case empty
      }
      
      var items: [Item]
      var totalItems: Int
    }
    
    struct ViewModel {
      struct Volume {
        var title: String
        var authors: String
        var publishedDate: String
        var description: String
        var imageURL: URL?
      }
      
      enum Item {
        case result(Volume)
        case loading(Volume)
        case empty
      }
      
      var items: [Item]
      var totalItems: String?
    }
  }
}

extension ViewModel.Volume {
  static let empty = ViewModel.Volume(
    title: "",
    authors: "",
    publishedDate: "",
    description: "",
    imageURL: nil)
}
