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
    // Outputs
    let alertMessage = Observable<String?>(nil) //에러
    let navigateQuery = Observable<String?>(nil) //성공
    
    // 문자열 길이 검증
    private let queryField = ValidatedField<String>(
        validator: { $0.trimmingCharacters(in: .whitespacesAndNewlines).count >= 2 },
        message: "검색어는 2글자 이상 입력해주세요."
    )
    
    func submit(_ text: String?) {
        print(#function)
        queryField.value.value = text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard queryField.validate() else {
            alertMessage.value = queryField.errorText.value
            return
        }
        navigateQuery.value = queryField.value.value
    }
}
