//
//  NetworkManager.swift
//  SeSAC0723Homework
//
//  Created by andev on 7/29/25.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() { }
    
    private let baseURL = "https://openapi.naver.com/v1/search/shop.json"
    
    private var clientId: String {
        Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_ID") as? String ?? ""
    }
    
    private var clientSecret: String {
        Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_SECRET") as? String ?? ""
    }
    
    private var headers: HTTPHeaders {
        [
            "X-Naver-Client-Id": clientId,
            "X-Naver-Client-Secret": clientSecret
        ]
    }
    
    // 네이버 쇼핑 검색 API
    func fetchShoppingItems(
        query: String,
        sort: String,
        start: Int,
        display: Int,
        completion: @escaping (Result<ShoppingResponse, AFError>) -> Void
    ) {
        let parameters: Parameters = [
            "query": query,
            "display": display,
            "start": start,
            "sort": sort
        ]
        
        AF.request(baseURL, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: ShoppingResponse.self) { response in
                completion(response.result)
            }
    }
    
    // 추천 아이템 조회
    func fetchRecommendedItems(completion: @escaping (Result<ShoppingResponse, AFError>) -> Void) {
        let parameters: Parameters = [
            "query": "새싹",
            "display": 10,
            "sort": "sim"
        ]
        
        AF.request(baseURL, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: ShoppingResponse.self) { response in
                completion(response.result)
            }
    }
}

