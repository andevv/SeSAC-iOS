//
//  TamagotchiDetailPopupViewModel.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/22/25.
//

import Foundation
import RxSwift
import RxCocoa

final class TamagotchiDetailPopupViewModel {

    private let tamagotchi: Tamagotchi

    init(tamagotchi: Tamagotchi) {
        self.tamagotchi = tamagotchi
    }

    struct Input {
        let cancelTap: Observable<Void>
        let startTap: Observable<Void>
    }

    struct Output {
        let title: Driver<String>
        let imageName: Driver<String>
        let desc: Driver<String>
        let dismiss: Observable<Void>
        let start: Observable<Tamagotchi>
    }

    func transform(input: Input) -> Output {
        let title = Driver.just(tamagotchi.name)
        let imageName = Driver.just(tamagotchi.imageName)
        let desc = Driver.just(tamagotchi.desc ?? "")

        let dismiss = input.cancelTap
        let start = input.startTap.map { [tamagotchi] in tamagotchi }

        return Output(title: title,
                      imageName: imageName,
                      desc: desc,
                      dismiss: dismiss,
                      start: start)
    }
}
