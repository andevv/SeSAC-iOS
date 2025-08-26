//
//  BoxOfficeViewModel.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/27/25.
//

import Foundation
import RxSwift
import RxCocoa

final class BoxOfficeViewModel: BaseViewModel {

    struct Input {
        let searchTap: ControlEvent<Void>
        let queryText: ControlProperty<String>
    }

    struct Output {
        let titles: Driver<[String]>
        let showToast: PublishRelay<Bool>
    }

    private let service: BoxOfficeService
    private let apiKey: String
    private let disposeBag = DisposeBag()

    init(service: BoxOfficeService = .shared, apiKey: String) {
        self.service = service
        self.apiKey = apiKey
    }

    func transform(input: Input) -> Output {
        let toast = PublishRelay<Bool>()

        // yyyyMMdd 형식만 통과
        let dateObs = input.queryText
            .asObservable()
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { Self.isValidDate($0) }

        let response = input.searchTap
            .withLatestFrom(dateObs)
            .distinctUntilChanged()
            .flatMap { [service, apiKey] date in
                service.fetch(date: date, apiKey: apiKey).asObservable()
            }
            .share(replay: 1, scope: .whileConnected)

        // 표시에 사용할 문자열 배열
        let titles = response
            .map { result -> [String] in
                switch result {
                case .success(let list):
                    let rows = list.map { "\($0.rank). \($0.movieNm)" }
                    return rows.isEmpty ? ["해당 날짜 결과 없음"] : rows
                case .failure:
                    return ["검색 실패"]
                }
            }
            .asDriver(onErrorJustReturn: ["검색 실패"])

        // 실패 시 토스트
        response
            .compactMap { result -> Bool? in
                if case .failure = result { return true }
                return nil
            }
            .bind(to: toast)
            .disposed(by: disposeBag)

        return Output(titles: titles, showToast: toast)
    }

    private static func isValidDate(_ s: String) -> Bool {
        s.range(of: #"^\d{8}$"#, options: .regularExpression) != nil
    }
}
