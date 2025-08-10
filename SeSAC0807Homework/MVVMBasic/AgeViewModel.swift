//
//  AgeViewModel.swift
//  MVVMBasic
//
//  Created by andev on 8/10/25.
//

import Foundation

enum AgeInputError: Error {
    case empty
    case notNumber
    case outOfRange
}

enum AgeResultColor {
    case normal
    case error
}

final class AgeViewModel {

    // Outputs
    var resultText: String = "여기에 결과를 보여주세요" {
        didSet { onResultTextChange?(resultText) }
    }
    var resultColor: AgeResultColor = .normal {
        didSet { onResultColorChange?(resultColor) }
    }

    // Bindings
    var onResultTextChange: ((String) -> Void)?
    var onResultColorChange: ((AgeResultColor) -> Void)?

    func didTapResult(inputText: String?) {
        do {
            let age = try validateAgeInput(inputText)
            resultText = "입력하신 나이는 \(age)세입니다."
            resultColor = .normal
        } catch {
            switch error {
            case AgeInputError.empty:
                resultText = "나이를 입력해주세요."
            case AgeInputError.notNumber:
                resultText = "숫자만 입력해주세요."
            case AgeInputError.outOfRange:
                resultText = "1~100 사이의 나이만 입력해주세요."
            default:
                resultText = "알 수 없는 오류가 발생했습니다."
            }
            resultColor = .error
        }
    }

    // Validation
    private func validateAgeInput(_ input: String?) throws -> Int {
        guard let input = input?.trimmingCharacters(in: .whitespacesAndNewlines), !input.isEmpty else {
            throw AgeInputError.empty
        }
        guard let age = Int(input) else {
            throw AgeInputError.notNumber
        }
        guard (1...100).contains(age) else {
            throw AgeInputError.outOfRange
        }
        return age
    }
}
