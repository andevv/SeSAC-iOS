//
//  CurrencyViewModel.swift
//  MVVMBasic
//
//  Created by andev on 8/9/25.
//

import Foundation

final class CurrencyViewModel {

    let resultText = Observable<String>("환전 결과가 여기에 표시됩니다")
    
    var exchangeRateText: String { "현재 환율: 1 USD = 1,350 KRW" }

    private let exchangeRate: Double = 1350.0

    func convert(fromKRW text: String) {
        guard let amount = Double(text) else {
            resultText.value = "올바른 금액을 입력해주세요"
            return
        }
        let converted = amount / exchangeRate
        resultText.value = String(format: "%.2f USD (약 $%.2f)", converted, converted)
    }
}
