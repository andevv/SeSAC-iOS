//
//  NameEditViewModel.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/24/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NameEditViewModel {

    private let disposeBag = DisposeBag()
    private let storage = TamagotchiStorage.shared

    struct Input {
        let viewWillAppear: Observable<Void>
        let nameText: Observable<String?>
        let saveTap: Observable<Void>
    }

    struct Output {
        let navTitle: Driver<String> // 네비 타이틀 텍스트
        let currentName: Driver<String> // 초기 텍스트
        let isSaveEnabled: Driver<Bool> // 2~6 글자만 활성화
        let didSave: Observable<Void> // 저장 성공
    }

    func transform(input: Input) -> Output {
        // 현재 저장된 이름
        let currentNameRelay = BehaviorRelay<String>(value: storage.leaderName)
        input.viewWillAppear
            .subscribe(onNext: { [weak self] in
                currentNameRelay.accept(self?.storage.leaderName ?? "")
            })
            .disposed(by: disposeBag)

        // 입력 텍스트
        let nameStream = input.nameText
            .map { ($0 ?? "").trimmingCharacters(in: .whitespacesAndNewlines) }
            .share(replay: 1) //최근 1개 공유

        // 2~6 글자 유효성 검증
        let isValid = nameStream
            .map { (2...6).contains($0.count) }
            .distinctUntilChanged()

        // 저장 시도
        let saveAttempt = input.saveTap
            .withLatestFrom(Observable.combineLatest(nameStream, isValid))

        // 저장 성공: UserDefaults 반영
        let didSave = saveAttempt
            .filter { $0.1 }
            .map { $0.0 }
            .do(onNext: { [weak self] name in
                self?.storage.leaderName = name
            })
            .map { _ in () }

        return Output(
            navTitle: Driver.just("대장님 이름 정하기"),
            currentName: currentNameRelay.asDriver(),
            isSaveEnabled: isValid.asDriver(onErrorJustReturn: false),
            didSave: didSave
        )
    }
}
