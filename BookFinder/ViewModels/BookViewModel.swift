//
//  BookViewModel.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/27.
//

import UIKit
import Alamofire
import RxAlamofire
import RxSwift
import RxCocoa

class BookViewModel {
  
  enum Item {
    case result(Volume)
    case loading(Volume)
    case empty
  }
  
  var items = BehaviorRelay<[Item]>(value: [])
  var resultText = BehaviorRelay<String?>(value: nil)
  var searchText = BehaviorRelay<String>(value: "")
  
  private(set) var disposeBag = DisposeBag()
  
  init() {
    bind()
  }
}

extension BookViewModel {
  private func bind() {
    let shared = searchText
      .flatMapLatest({ [weak self] text -> Observable<Volume.List> in
        guard let self = self else { return Observable.just(.empty) }
        guard text.count > 0 else { return Observable.just(.empty) }
        
        let count = self.items.value.count
        
        return HttpClient.fetchVolumes(text: text, index: count)
      })
      .catchAndReturn(.empty)
      .share()
    
    shared.map(\.totalItems)
      .map({ $0 > 0 ? String("\($0) results") : nil })
      .bind(to: resultText)
      .disposed(by: disposeBag)
        
    shared.map(\.items)
      .map({ [weak self] items -> [Item] in
        guard let self = self else { return [] }
        let current = self.items.value.filter { state in
          guard case .result = state else { return false }
          return true
        }
        let incomes: [Item] = items?.map({ .result($0) }) ?? [.empty]
        return current + incomes
      })
      .bind(to: items)
      .disposed(by: disposeBag)
  }
  
  func search(for text: String) {
    searchText.accept(text)
  }
    
  func reset(_: String) {
    items.accept([Item](repeating: .loading(.empty), count: 20))
    resultText.accept(nil)
  }
}
