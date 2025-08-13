//
//  ShoppingRouter.swift
//  SeSAC0723Homework
//
//  Created by andev on 8/13/25.
//

import Foundation
import Alamofire

enum ShopRouter: URLRequestConvertible {

    // 검색
    case search(query: String, sort: String, start: Int, display: Int)
    // 추천
    case recommended

    private var baseURL: URL {
        // 네이버 쇼핑 검색 API
        return URL(string: "https://openapi.naver.com/v1/search/shop.json")!
    }

    private static var clientId: String {
        Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_ID") as? String ?? ""
    }

    private static var clientSecret: String {
        Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_SECRET") as? String ?? ""
    }

    private var method: HTTPMethod {
        return .get
    }

    private var headers: HTTPHeaders {
        [
            "X-Naver-Client-Id": Self.clientId,
            "X-Naver-Client-Secret": Self.clientSecret
        ]
    }

    private var parameters: Parameters {
        switch self {
        case let .search(query, sort, start, display):
            return [
                "query": query,
                "display": display,
                "start": start,
                "sort": sort
            ]
        case .recommended:
            return [
                "query": "새싹",
                "display": 10,
                "sort": "sim"
            ]
        }
    }

    func asURLRequest() throws -> URLRequest {
        var request = try URLRequest(url: baseURL, method: method, headers: headers)
        request = try URLEncoding(destination: .queryString).encode(request, with: parameters)
        return request
    }
}
