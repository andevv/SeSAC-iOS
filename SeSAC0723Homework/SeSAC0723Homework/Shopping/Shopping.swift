//
//  Shopping.swift
//  SeSAC0723Homework
//
//  Created by andev on 7/26/25.
//

import Foundation

struct ShoppingResponse: Decodable {
    let total: Int
    let items: [ShoppingItem]
}

struct ShoppingItem: Decodable {
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
}
