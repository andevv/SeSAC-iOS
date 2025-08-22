//
//  TamagotchiCatalog.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/22/25.
//

import Foundation

// 앱 전역에서 동일한 데이터로 재구성하기 위한 카탈로그
enum TamagotchiCatalog {
    static let available: [Tamagotchi] = [
        .init(id: 1, name: "따끈따끈 다마고치", imageName: "1-6", isAvailable: true, desc: "따끈따끈 다마고치입니다"),
        .init(id: 2, name: "방실방실 다마고치", imageName: "2-6", isAvailable: true, desc: "방실방실 다마고치입니다"),
        .init(id: 3, name: "반짝반짝 다마고치", imageName: "3-6", isAvailable: true, desc: "반짝반짝 다마고치입니다"),
    ]

    static func find(by id: Int) -> Tamagotchi? {
        // 선택 불가 슬롯은 필요 시 추가 가능. 현재는 3종만 복원.
        return available.first { $0.id == id }
    }
}
