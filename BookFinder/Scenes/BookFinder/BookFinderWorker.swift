//
//  BookFinderWorker.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/29.
//

import Foundation
import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa

class BookFinderWorker {
  
  var searchText = BehaviorRelay<String>(value: "")
  var totalItems = BehaviorRelay<Int>(value: 0)
  var items = BehaviorRelay<[Response.Item]>(value: [])
  
  private let disposeBag = DisposeBag()
  
  init() {
    bind()
  }
}

extension BookFinderWorker {
  private func bind() {
    let shared = searchText
      .flatMapLatest({ [weak self] (text) -> Observable<Volume.List> in
        guard let self = self else { return Observable.just(.empty) }
        guard text.count > 0 else { return Observable.just(.empty) }
        
        let count = self.items.value.count
        
        return HttpClient.fetchVolumes(text: text, index: count)
      })
      .catchAndReturn(.empty)
      .share()
    
    shared.map(\.totalItems)
      .bind(to: totalItems)
      .disposed(by: disposeBag)
        
    shared.map(\.items)
      .map({ [weak self] (items) -> [Response.Item] in
        guard let self = self else { return [] }
        let current = self.items.value.filter { state in
          guard case .result = state else { return false }
          return true
        }
        let incomes: [Response.Item] = items?.map({ .result($0) }) ?? [.empty]
        return current + incomes
      })
      .bind(to: items)
      .disposed(by: disposeBag)
  }
  
  func fetch(request: Request) {
    searchText.accept(request.searchText)
  }
    
  func reset() {
    items.accept([Response.Item](repeating: .loading(.empty), count: 20))
    totalItems.accept(0)
  }
}
