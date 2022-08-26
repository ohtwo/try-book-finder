//
//  HttpRoutable.swift
//  BookFinder
//
//  Created by Kang Byeonghak on 2022/08/26.
//

import Foundation
import Alamofire

protocol HttpRoutable: URLConvertible, URLRequestConvertible {
  var host: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
  var headers: HTTPHeaders? { get }
  var parameters: Parameters? { get }
  var encoder: ParameterEncoder { get }
}

extension HttpRoutable {
  func asURL() throws -> URL {
    guard let url = URL(string: host)?.appendingPathComponent(path) else {
      throw AFError.invalidURL(url: host)
    }
    return url
  }
  
  func asURLRequest() throws -> URLRequest {
    let url = try asURL()
    let request = try URLRequest(url: url, method: method, headers: headers)
    let encoded = try encoder.encode(parameters, into: request)

    return encoded
  }
}

struct Parameters: Encodable {
  let parameters: Encodable

  init(_ parameters: Encodable) {
    self.parameters = parameters
  }

  func encode(to encoder: Encoder) throws {
    return try parameters.encode(to: encoder)
  }
}
