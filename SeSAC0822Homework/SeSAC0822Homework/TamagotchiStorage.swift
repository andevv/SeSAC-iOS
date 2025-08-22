//
//  TamagotchiStorage.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/22/25.
//

import Foundation

final class TamagotchiStorage {
    static let shared = TamagotchiStorage()
    private init() {}

    private let kSelectedID = "tg.selected.id"
    private let kRice = "tg.rice"
    private let kWater = "tg.water"
    private let kLeader = "tg.leader.name"

    var selectedID: Int? {
        get { UserDefaults.standard.object(forKey: kSelectedID) as? Int }
        set { UserDefaults.standard.setValue(newValue, forKey: kSelectedID) }
    }

    var riceCount: Int {
        get { UserDefaults.standard.integer(forKey: kRice) }
        set { UserDefaults.standard.setValue(max(0, newValue), forKey: kRice) }
    }

    var waterCount: Int {
        get { UserDefaults.standard.integer(forKey: kWater) }
        set { UserDefaults.standard.setValue(max(0, newValue), forKey: kWater) }
    }
    var leaderName: String {
        get { UserDefaults.standard.string(forKey: kLeader) ?? "대장님" }
        set { UserDefaults.standard.setValue(newValue, forKey: kLeader) }
    }

    func select(_ t: Tamagotchi) {
        selectedID = t.id
        // 첫 선택 시 카운트 초기화
        riceCount = 0
        waterCount = 0
    }

    func resetAll() {
        selectedID = nil
        riceCount = 0
        waterCount = 0
        leaderName = "대장님"
    }
}
