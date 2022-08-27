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
  var totalItems = BehaviorRelay<Int>(value: 0)
  var searchText = ""
  
  private(set) var disposeBag = DisposeBag()
}

extension BookViewModel {
  func search(for text: String) {
    guard text.count > 0 else { return }
    
    searchText = text
    
    let current = volumes.value
    let shared = HttpClient.fetchVolumes(text: text, index: current.count)
      .catchAndReturn(.empty)
      .share()
    
    shared.map(\.totalItems)
      .bind(to: totalItems)
      .disposed(by: disposeBag)
    
    shared.map({ current + ($0.items ?? []) })
      .bind(to: volumes)
      .disposed(by: disposeBag)
  }
  
  func reset() {
    disposeBag = DisposeBag()
    volumes.accept([])
  }
}
