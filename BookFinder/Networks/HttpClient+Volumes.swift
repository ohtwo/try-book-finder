//
//  HttpClient+Volumes.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/27.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire

extension HttpClient {
  static func fetchVolumes(text: String, index: Int) -> Observable<Volume.List> {
    let route = HttpRouter.Volumes.search(text: text, index: index)
    
    return Observable.just(route)
      .flatMap({
        HttpClient.request($0).rx.responseDecodable()
      })
      .map({ $0.1 })
      .debug(#function)
  }
}
