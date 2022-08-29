//
//  BookFinderPresenter.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/29.
//

import Foundation

protocol BookFinderPresentable {
  func presentFetchedBooks(response: Response)
}

class BookFinderPresenter: BookFinderPresentable {
  weak var viewer: BookFinderViewable?
  
  func presentFetchedBooks(response: Response) {
    var items: [ViewModel.Item] = []
    
    for item in response.items {
      switch item {
      case let .result(volume):
        let mapped = ViewModel.Volume(
          title: volume.info.title,
          authors: volume.info.authorsText,
          publishedDate: volume.info.publishedDateText,
          description: volume.info.descriptionText,
          imageURL: volume.info.smallThumbnailURL)
        
        items.append(.result(mapped))
        
      case .loading:
        items.append(.loading(.empty))
        
      case .empty:
        items.append(.empty)
      }
    }
    
    let count = response.totalItems
    let result = count > 0 ? String("\(count) results") : nil
    
    let viewModel = ViewModel(items: items, totalItems: result)
    viewer?.displayFetchedBooks(viewModel: viewModel)
  }
}
