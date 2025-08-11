//
//  MapViewModel.swift
//  MVVMBasic
//
//  Created by andev on 8/11/25.
//

import Foundation

enum RestaurantCategory: String, CaseIterable {
    case all = "전체"
    case korean = "한식"
    case western = "양식"
    case chinese = "중식"
    case japanese = "일식"
    case snack = "분식"
    case cafe = "카페"
    case other = "기타"

    init(from raw: String) {
        if let c = RestaurantCategory.allCases.first(where: { $0.rawValue == raw }) {
            self = c
        } else {
            self = .other
        }
    }

    static var segmentTitles: [String] {
        return RestaurantCategory.allCases.map { $0.rawValue }
    }
}

final class MapViewModel {

    // 전체 원본 데이터
    private let allRestaurants: [Restaurant] = RestaurantList.restaurantArray

    // 상태
    let selectedCategory = Observable<RestaurantCategory>(.all)
    let restaurants = Observable<[Restaurant]>(RestaurantList.restaurantArray)

    init() {
        // 카테고리 변경 -> 필터링 반영
        selectedCategory.bind({ _ in
            self.applyFilter()
        })
    }

    func setCategory(_ category: RestaurantCategory) {
        selectedCategory.value = category
    }

    private func applyFilter() {
        let category = selectedCategory.value
        if category == .all {
            restaurants.value = allRestaurants
        } else {
            restaurants.value = allRestaurants.filter { RestaurantCategory(from: $0.category) == category }
        }
    }
}
