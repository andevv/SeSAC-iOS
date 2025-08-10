//
//  BMIViewModel.swift
//  MVVMBasic
//
//  Created by andev on 8/10/25.
//

import Foundation

enum BMIInputError: Error {
    case emptyHeight
    case emptyWeight
    case notNumber
    case heightOutOfRange
    case weightOutOfRange
}

final class BMIViewModel {
    
    var resultText: String = "여기에 결과를 보여주세요" {
        didSet { onResultTextChange?(resultText) }
    }
    
    // alert
    enum Event {
        case showAlert(String)
    }
    var event: Event? {
        didSet { if let event = event { onEvent?(event) } }
    }
    
    // Bindings
    var onResultTextChange: ((String) -> Void)?
    var onEvent: ((Event) -> Void)?

    func didTapResult(heightText: String?, weightText: String?) {
        do {
            let (h, w) = try validateBMIInput(heightInput: heightText, weightInput: weightText)
            let bmi = w / ((h / 100) * (h / 100))
            resultText = String(format: "BMI: %.2f", bmi)
        } catch {
            resultText = ""
            event = .showAlert(message(for: error))
        }
    }
    
    // Validation
    private func validateBMIInput(heightInput: String?, weightInput: String?) throws -> (Double, Double) {
        guard let hInput = heightInput?.trimmingCharacters(in: .whitespacesAndNewlines), !hInput.isEmpty else {
            throw BMIInputError.emptyHeight
        }
        guard let wInput = weightInput?.trimmingCharacters(in: .whitespacesAndNewlines), !wInput.isEmpty else {
            throw BMIInputError.emptyWeight
        }
        guard let height = Double(hInput), let weight = Double(wInput) else {
            throw BMIInputError.notNumber
        }
        // 키 90~250cm, 몸무게 20~200kg 범위
        guard (90...250).contains(height) else {
            throw BMIInputError.heightOutOfRange
        }
        guard (20...200).contains(weight) else {
            throw BMIInputError.weightOutOfRange
        }
        return (height, weight)
    }
    
    // 에러메시지
    private func message(for error: Error) -> String {
        switch error {
        case BMIInputError.emptyHeight:       return "키를 입력해주세요."
        case BMIInputError.emptyWeight:       return "몸무게를 입력해주세요."
        case BMIInputError.notNumber:         return "숫자만 입력해주세요."
        case BMIInputError.heightOutOfRange:  return "키는 90~250cm 범위만 허용됩니다."
        case BMIInputError.weightOutOfRange:  return "몸무게는 20~200kg 범위만 허용됩니다."
        default:                              return "알 수 없는 오류가 발생했습니다."
        }
    }
}
