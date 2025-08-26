//
//  SettingsViewModel.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/24/25.
//

import Foundation
import RxSwift
import RxCocoa

struct SettingsRowViewModel {
    let systemImage: String
    let title: String
    let value: String?
    let showsChevron: Bool
    let action: SettingsAction
}

enum SettingsAction {
    case editName
    case changeTamagotchi
    case resetData
}

final class SettingsViewModel {

    private let disposeBag = DisposeBag()
    private let storage = TamagotchiStorage.shared

    struct Input {
        let viewWillAppear: Observable<Void>
        let selectRow: Observable<IndexPath>
        let confirmReset: Observable<Void> // 알럿 확인 탭
    }

    struct Output {
        let navTitle: Driver<String>
        let rows: Driver<[SettingsRowViewModel]>
        let routeEditName: Observable<Void>
        let routeChange: Observable<Void>
        let askResetConfirm: Observable<Void>
        let didReset: Observable<Void>
        let currentLeaderName: Driver<String>
    }

    func transform(input: Input) -> Output {
        // 현재 사용자 이름
        let leaderName = BehaviorRelay<String>(value: storage.leaderName)

        // 화면이 다시 보이면 최신 이름 반영
        input.viewWillAppear
            .subscribe(onNext: { [weak self] in
                leaderName.accept(self?.storage.leaderName ?? "대장님")
            })
            .disposed(by: disposeBag)

        let rows = leaderName
            .map { name -> [SettingsRowViewModel] in
                return [
                    .init(systemImage: "pencil", title: "내 이름 설정하기", value: name, showsChevron: true, action: .editName),
                    .init(systemImage: "moon.fill", title: "다마고치 변경하기", value: nil, showsChevron: true, action: .changeTamagotchi),
                    .init(systemImage: "arrow.clockwise", title: "데이터 초기화", value: nil, showsChevron: true, action: .resetData)
                ]
            }
            .asDriver(onErrorJustReturn: [])

        let selectedAction = input.selectRow
            .withLatestFrom(rows.asObservable()) { indexPath, items in
                items[indexPath.row].action
            }
            .share()

        let routeEditName = selectedAction.filter { $0 == .editName }.map { _ in () }
        let routeChange = selectedAction.filter { $0 == .changeTamagotchi }.map { _ in () }
        let askReset = selectedAction.filter { $0 == .resetData }.map { _ in () }

        let didReset = input.confirmReset
            .do(onNext: { [weak self] in self?.storage.resetAll() })
            .map { _ in () }

        return Output(
            navTitle: Driver.just("설정"),
            rows: rows,
            routeEditName: routeEditName,
            routeChange: routeChange,
            askResetConfirm: askReset,
            didReset: didReset,
            currentLeaderName: leaderName.asDriver()
        )
    }
}
