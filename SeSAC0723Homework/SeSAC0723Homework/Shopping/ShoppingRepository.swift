//
//  ShoppingRepository.swift
//  SeSAC0723Homework
//
//  Created by andev on 8/12/25.
//

import Foundation

protocol ShoppingRepository {
    func fetchItems(query: String, sort: String, completion: @escaping (Result<ShoppingResponse, Error>) -> Void)
    func fetchRecommended(completion: @escaping (Result<ShoppingResponse, Error>) -> Void)
}

struct NetworkShoppingRepository: ShoppingRepository {
    func fetchItems(query: String, sort: String, completion: @escaping (Result<ShoppingResponse, Error>) -> Void) {
        NetworkManager.shared.fetchShoppingItems(query: query, sort: sort, start: 1, display: 100) { result in
            switch result {
            case .success(let res): completion(.success(res))
            case .failure(let err): completion(.failure(err))
            }
        }
    }
    
    func fetchRecommended(completion: @escaping (Result<ShoppingResponse, Error>) -> Void) {
        NetworkManager.shared.fetchRecommendedItems { result in
            switch result {
            case .success(let res): completion(.success(res))
            case .failure(let err): completion(.failure(err))
            }
        }
    }
}
