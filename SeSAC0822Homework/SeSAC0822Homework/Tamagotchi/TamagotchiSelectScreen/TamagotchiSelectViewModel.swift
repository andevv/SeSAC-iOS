//
//  TamagotchiSelectViewModel.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/22/25.
//

import Foundation
import RxSwift
import RxCocoa

struct TamagotchiCellViewModel {
    let title: String
    let imageName: String
    let isAvailable: Bool
}

final class TamagotchiSelectViewModel {
    
    private static func makeItems() -> [Tamagotchi] {
        var result: [Tamagotchi] = []
        
        // 선택 가능한 3개
        let first3: [Tamagotchi] = [
            .init(id: 1, name: "따끈따끈 다마고치", imageName: "1-6", isAvailable: true, desc: "따끈따끈 다마고치입니다\n따끈따끈\n따끈따끈\n따끈따끈"),
            .init(id: 2, name: "방실방실 다마고치", imageName: "2-6", isAvailable: true, desc: "방실방실 다마고치입니다\n방실방실\n방실방실\n방실방실"),
            .init(id: 3, name: "반짝반짝 다마고치", imageName: "3-6", isAvailable: true, desc: "반짝반짝 다마고치입니다\n반짝반짝\n반짝반짝\n반짝반짝")
        ]
        result.append(contentsOf: first3)
        
        var nextId = 4
        // 총 21개 -> 18개 플레이스홀더 추가
        for _ in 0..<18 {
            result.append(.init(id: nextId,
                                name: "준비중이에요",
                                imageName: "noImage",
                                isAvailable: false,
                                desc: nil))
            nextId += 1
        }
        return result
    }
    
    private let itemsRelay = BehaviorRelay<[Tamagotchi]>(value: TamagotchiSelectViewModel.makeItems())
    
    struct Input {
        let itemSelected: Observable<IndexPath>
    }
    
    struct Output {
        let items: Driver<[TamagotchiCellViewModel]> // 컬렉션 뷰 표시용
        let selectedAvailable: Observable<Tamagotchi> // 사용 가능 3종 선택
        let showInfo: Observable<String> // 준비중 탭 시 메시지
    }
    
    func transform(input: Input) -> Output {
        let itemsDriver = itemsRelay
            .map { list in
                list.map { t in
                    TamagotchiCellViewModel(
                        title: t.isAvailable ? t.name : "준비중이에요",
                        imageName: t.imageName,
                        isAvailable: t.isAvailable
                    )
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        let tappedModel = input.itemSelected
            .withLatestFrom(itemsRelay) { indexPath, models in models[indexPath.item] }
            .share()
        
        let selectedAvailable = tappedModel
            .filter { $0.isAvailable }
        
        let showInfo = tappedModel
            .filter { !$0.isAvailable }
            .map { _ in "아직 준비중인 다마고치입니다" }
        
        return Output(items: itemsDriver, selectedAvailable: selectedAvailable, showInfo: showInfo)
    }
}
