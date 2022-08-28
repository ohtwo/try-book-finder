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
  
  var volumes = BehaviorRelay<[Volume]>(value: [])
  var totalItems = BehaviorRelay<String?>(value: nil)
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
        
        let count = self.volumes.value.count
        
        return HttpClient.fetchVolumes(text: text, index: count)
      })
      .catchAndReturn(.empty)
      .share()
    
    shared.map(\.totalItems)
      .map({ $0 > 0 ? String("\($0) results") : nil })
      .bind(to: totalItems)
      .disposed(by: disposeBag)
        
    shared.map(\.items)
      .map({ [weak self] items -> [Volume] in
        guard let self = self else { return [] }
        return self.volumes.value + (items ?? [])
      })
      .bind(to: volumes)
      .disposed(by: disposeBag)
  }
  
  func search(for text: String) {
    searchText.accept(text)
  }
    
  func reset(_: String) {
    volumes.accept([])
    totalItems.accept(nil)
  }
}
