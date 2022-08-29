//
//  BookFinderInteractor.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/29.
//

import Foundation
import RxSwift
import RxCocoa

protocol BookFinderInteractable {
  func fetchBooks(request: Request)
  func prepareForFetch()
}

protocol BookFinderDataStore
{
  var items: [Response.Item]? { get }
}

class BookFinderInteractor: BookFinderInteractable, BookFinderDataStore {
  
  var presenter: BookFinderPresentable?
  var worker = BookFinderWorker()
  
  var items: [Response.Item]?
  
  private var disposeBag = DisposeBag()
  
  init() {
    bind()
  }
  
  func bind() {
    worker.items.asDriver()
      .drive(onNext: { [weak self] (items) in
        guard let self = self else { return }
        self.items = items
        
        let response = Response(items: items, totalItems: self.worker.totalItems.value)
        self.presenter?.presentFetchedBooks(response: response)
      })
      .disposed(by: disposeBag)
  }
  
  func fetchBooks(request: Request) {
    worker.fetch(request: request)
  }
  
  func prepareForFetch() {
    worker.reset()
  }
}
