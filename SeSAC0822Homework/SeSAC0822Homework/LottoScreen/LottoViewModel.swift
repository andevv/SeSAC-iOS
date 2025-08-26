//
//  LottoViewModel.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/26/25.
//

import Foundation
import RxSwift
import RxCocoa

final class LottoViewModel: BaseViewModel {

    struct Input {
        let searchTap: ControlEvent<Void>
        let queryText: ControlProperty<String>
    }

    struct Output {
        let resultText: Driver<String>
        let showToast: PublishRelay<Bool>
    }

    private let service: LottoService
    private let disposeBag = DisposeBag()

    init(service: LottoService = .shared) {
        self.service = service
    }

    func transform(input: Input) -> Output {
        let toast = PublishRelay<Bool>()

        // 숫자 회차만 추출
        let validDrawObs = input.queryText
            .asObservable()
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .map(Int.init)
            .compactMap { $0 }

        let response = input.searchTap
            .withLatestFrom(validDrawObs)
            .flatMap { [service] draw in
                service.fetch(draw: draw).asObservable()
            }
            .share(replay: 1, scope: .whileConnected)

        // 결과 텍스트
        let resultText = response
            .map { result -> String in
                switch result {
                case .success(let lotto):
                    let nums = [lotto.drwtNo1, lotto.drwtNo2, lotto.drwtNo3,
                                lotto.drwtNo4, lotto.drwtNo5, lotto.drwtNo6]
                    return nums.map(String.init).joined(separator: "  ") + "  +  \(lotto.bnusNo)"
                case .failure:
                    return "회차를 다시 확인해주세요."
                }
            }
            .asDriver(onErrorJustReturn: "알 수 없는 오류가 발생했습니다.")

        // 통신/디코딩 실패 시 토스트
        response
            .compactMap { result -> Bool? in
                if case .failure = result { return true }
                return nil
            }
            .bind(to: toast)
            .disposed(by: disposeBag)

        return Output(
            resultText: resultText,
            showToast: toast
        )
    }
}
