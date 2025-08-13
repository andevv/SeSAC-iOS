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
    
    // 단일 메서드로 모든 요청 처리
    func request<T: Decodable>(
        _ route: URLRequestConvertible,
        type: T.Type,
        completion: @escaping (Result<T, AFError>) -> Void
    ) -> DataRequest {
        return AF.request(route)
            .validate()
            .responseDecodable(of: T.self) { response in
                completion(response.result)
            }
    }
}
