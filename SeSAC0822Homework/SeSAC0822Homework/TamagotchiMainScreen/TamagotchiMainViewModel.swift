//
//  TamagotchiMainViewModel.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/22/25.
//

import Foundation
import RxSwift
import RxCocoa

// 입력 검증 에러 타입 (LocalizedError로 메시지 바로 사용)
private enum FeedInputError: LocalizedError {
    case invalidNumber
    case overLimit

    var errorDescription: String? {
        switch self {
        case .invalidNumber: return "숫자를 올바르게 입력해주세요."
        case .overLimit: return "밥은 한 번에 99개까지만 먹을 수 있어요!"
        }
    }
}

private enum DrinkInputError: LocalizedError {
    case invalidNumber
    case overLimit

    var errorDescription: String? {
        switch self {
        case .invalidNumber: return "숫자를 올바르게 입력해주세요."
        case .overLimit: return "물은 한 번에 49방울까지만 먹을 수 있어요!"
        }
    }
}

final class TamagotchiMainViewModel {

    private let disposeBag = DisposeBag()
    private let tg: Tamagotchi
    private let storage = TamagotchiStorage.shared

    // 상태
    private let rice = BehaviorRelay<Int>(value: TamagotchiStorage.shared.riceCount)
    private let water = BehaviorRelay<Int>(value: TamagotchiStorage.shared.waterCount)

    init(tamagotchi: Tamagotchi) { self.tg = tamagotchi }

    struct Input {
        let viewWillAppear: Observable<Void>
        let feedTap: Observable<Void>
        let drinkTap: Observable<Void>
        let feedText: Observable<String?>
        let drinkText: Observable<String?>
    }

    struct Output {
        let navTitle: Driver<String>
        let imageName: Driver<String>
        let namePill: Driver<String>
        let statusText: Driver<String>
        let bubbleText: Driver<String>
        let showAlert: Observable<String>
        let clearFeed: Observable<Void>
        let clearDrink: Observable<Void>
    }

    func transform(input: Input) -> Output {

        // 증가 로직
        let feedAmount: Observable<Result<Int, FeedInputError>> = input.feedTap
            .withLatestFrom(input.feedText.startWith(nil))
            .map { text -> Result<Int, FeedInputError> in
                let trimmed = (text ?? "").trimmingCharacters(in: .whitespaces)
                if trimmed.isEmpty { return .success(1) }
                guard let v = Int(trimmed), v > 0 else { return .failure(.invalidNumber) }
                guard v <= 99 else { return .failure(.overLimit) }
                return .success(v)
            }

        let drinkAmount: Observable<Result<Int, DrinkInputError>> = input.drinkTap
            .withLatestFrom(input.drinkText.startWith(nil))
            .map { text -> Result<Int, DrinkInputError> in
                let trimmed = (text ?? "").trimmingCharacters(in: .whitespaces)
                if trimmed.isEmpty { return .success(1) }
                guard let v = Int(trimmed), v > 0 else { return .failure(.invalidNumber) }
                guard v <= 49 else { return .failure(.overLimit) }
                return .success(v)
            }

        let feedOK = feedAmount.compactMap { try? $0.get() }
        let feedNG = feedAmount.compactMap { result -> String? in
            if case let .failure(err) = result { return err.localizedDescription }
            return nil
        }

        let drinkOK = drinkAmount.compactMap { try? $0.get() }
        let drinkNG = drinkAmount.compactMap { result -> String? in
            if case let .failure(err) = result { return err.localizedDescription }
            return nil
        }

        // 카운트 증가 및 저장 동기화
        feedOK.withLatestFrom(rice) { inc, cur in min(cur + inc, Int.max) }
            .bind(to: rice)
            .disposed(by: disposeBag)

        drinkOK.withLatestFrom(water) { inc, cur in min(cur + inc, Int.max) }
            .bind(to: water)
            .disposed(by: disposeBag)

        rice.skip(1)
            .subscribe(onNext: { TamagotchiStorage.shared.riceCount = $0 })
            .disposed(by: disposeBag)
        water.skip(1)
            .subscribe(onNext: { TamagotchiStorage.shared.waterCount = $0 })
            .disposed(by: disposeBag)

        // 레벨 & 이미지
        let index: Observable<Double> = Observable.combineLatest(rice.asObservable(), water.asObservable())
            .map { r, w in Double(r) / 5.0 + Double(w) / 2.0 }

        let level = index
            .map { idx in max(1, min(10, Int(idx / 10.0))) }

        let imageIndex = index
            .map { idx in max(1, min(9, Int(idx / 10.0))) }

        let species = speciesIndex(for: tg) // 1/2/3
        let imageName = imageIndex
            .map { "\(species)-\($0)" }
            .asDriver(onErrorJustReturn: "noImage")

        // 텍스트
        let riceChanged = rice.asObservable().map { _ in () as Void }
        let waterChanged = water.asObservable().map { _ in () as Void }

        let navTitle = Observable
            .merge(input.viewWillAppear, riceChanged, waterChanged)
            .map { [weak self] _ in "\(self?.storage.leaderName ?? "대장")의 다마고치" }
            .asDriver(onErrorJustReturn: "대장님의 다마고치")

        let namePill = Driver.just(tg.name)

        let statusText = Observable.combineLatest(level, rice.asObservable(), water.asObservable())
            .map { lv, r, w in "LV\(lv) · 밥알 \(r)개 · 물방울 \(w)개" }
            .asDriver(onErrorJustReturn: "LV1 · 밥알 0개 · 물방울 0개")

        // 말풍선
        let bubbleOnAppear = input.viewWillAppear.map { [weak self] in self?.makeBubble(reason: .appear) ?? "" }
        let bubbleOnFeed   = feedOK.map { [weak self] _ in self?.makeBubble(reason: .feed) ?? "" }
        let bubbleOnDrink  = drinkOK.map { [weak self] _ in self?.makeBubble(reason: .drink) ?? "" }

        let bubbleText = Observable.merge(bubbleOnAppear, bubbleOnFeed, bubbleOnDrink)
            .asDriver(onErrorJustReturn: "")

        let showAlert = Observable.merge(feedNG, drinkNG)

        return Output(
            navTitle: navTitle,
            imageName: imageName,
            namePill: namePill,
            statusText: statusText,
            bubbleText: bubbleText,
            showAlert: showAlert,
            clearFeed: feedOK.map { _ in () },
            clearDrink: drinkOK.map { _ in () }
        )
    }

    private func speciesIndex(for t: Tamagotchi) -> Int {
        if t.imageName.hasPrefix("1-") || t.id == 1 { return 1 }
        if t.imageName.hasPrefix("2-") || t.id == 2 { return 2 }
        return 3
    }

    private enum BubbleReason { case appear, feed, drink }
    private func makeBubble(reason: BubbleReason) -> String {
        let leader = storage.leaderName
        switch reason {
        case .appear:
            return ["\(leader), 좋은 하루예요!",
                    "\(leader)님, 오늘도 화이팅!",
                    "복습 하셨나요 \(leader)?"].randomElement()!
        case .feed:
            return ["밥 잘 먹고 힘이 나요 \(leader)!",
                    "\(leader) 덕분에 든든해요!",
                    "냠냠! 고마워요 \(leader)"].randomElement()!
        case .drink:
            return ["시원한 물 최고예요 \(leader)!",
                    "촉촉해졌어요, \(leader)!",
                    "꿀꺽! 감사해요 \(leader)"].randomElement()!
        }
    }
}
