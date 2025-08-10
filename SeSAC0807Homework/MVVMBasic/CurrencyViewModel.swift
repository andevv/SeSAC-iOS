//
//  CurrencyViewModel.swift
//  MVVMBasic
//
//  Created by andev on 8/9/25.
//

import Foundation

final class CurrencyViewModel {

    var onResultTextChange: ((String) -> Void)?

    private let exchangeRate: Double = 1350.0
    var resultText: String = "환전 결과가 여기에 표시됩니다" {
        didSet { onResultTextChange?(resultText) }
    }

    var exchangeRateText: String {
        return "현재 환율: 1 USD = 1,350 KRW"
    }

    func convert(fromKRW text: String) {
        guard let amount = Double(text) else {
            resultText = "올바른 금액을 입력해주세요"
            return
        }
        let converted = amount / exchangeRate
        resultText = String(format: "%.2f USD (약 $%.2f)", converted, converted)
    }
}
