//
//  SearchViewModel.swift
//  SeSAC0723Homework
//
//  Created by andev on 8/12/25.
//

import Foundation

// 유효성 검증 로직
final class ValidatedField<T> {
    let value: Observable<T?>
    let errorText = Observable<String?>(nil)
    private let validator: (T) -> Bool
    private let message: String
    
    init(initial: T? = nil, validator: @escaping (T) -> Bool, message: String) {
        self.value = Observable<T?>(initial)
        self.validator = validator
        self.message = message
    }
    
    // input타입 관계없이 validate() 가능
    func validate() -> Bool {
        guard let v = value.value, validator(v) else {
            errorText.value = message
            return false
        }
        errorText.value = nil
        return true
    }
}

final class ShoppingViewModel {

    struct Input {
        // 검색어 텍스트
        let searchText: Observable<String?>
        // 검색 버튼 탭 트리거
        let searchTap: Observable<Void?>
    }

    struct Output {
        // 경고 메시지 (검증 실패)
        let alertMessage: Observable<String?>
        // 네비게이션 트리거(검증 성공 시 쿼리 전달)
        let navigateQuery: Observable<String?>
    }

    private let queryField = ValidatedField<String>(
        validator: { $0.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2 },
        message: "검색어는 2글자 이상 입력해주세요."
    )

    func transform(_ input: Input) -> Output {
        let alertMessage = Observable<String?>(nil)
        let navigateQuery = Observable<String?>(nil)

        // searchTap이 올라오면 현재 searchText를 검증 후 라우팅
        input.searchTap.lazyBind { [weak self] in
            guard let self = self else { return }
            self.queryField.value.value = input.searchText.value?.trimmingCharacters(in: .whitespacesAndNewlines)
            if self.queryField.validate() {
                navigateQuery.value = self.queryField.value.value
            } else {
                alertMessage.value = self.queryField.errorText.value
            }
        }

        return Output(alertMessage: alertMessage, navigateQuery: navigateQuery)
    }
}
