//
//  BirthDayViewModel.swift
//  MVVMBasic
//
//  Created by andev on 8/10/25.
//

import Foundation

enum BirthInputError: Error {
    case emptyYear
    case emptyMonth
    case emptyDay
    case notNumber
    case yearOutOfRange
    case monthOutOfRange
    case dayOutOfRange
    case invalidDate
}

final class BirthDayViewModel {
    
    var resultText: String = "여기에 결과를 보여주세요" {
        didSet { onResultTextChange?(resultText) }
    }
    
    // alert 이벤트
    enum Event {
        case showAlert(String)
    }
    var event: Event? {
        didSet { if let event = event { onEvent?(event) } }
    }
    
    // Bindings
    var onResultTextChange: ((String) -> Void)?
    var onEvent: ((Event) -> Void)?
    
    func didTapResult(yearText: String?, monthText: String?, dayText: String?) {
        do {
            let birthDate = try validateBirthInput(yearText: yearText,
                                                   monthText: monthText,
                                                   dayText: dayText)
            let today = Calendar.current.startOfDay(for: Date())
            let birthDay = Calendar.current.startOfDay(for: birthDate)
            let days = Calendar.current.dateComponents([.day], from: birthDay, to: today).day ?? 0
            resultText = "D+\(days + 1) 일째 입니다."
        } catch {
            resultText = ""
            event = .showAlert(message(for: error))
        }
    }
    
    // Validation
    private func validateBirthInput(yearText: String?, monthText: String?, dayText: String?) throws -> Date {
        // 빈 값
        guard let y = yearText?.trimmingCharacters(in: .whitespacesAndNewlines), !y.isEmpty else {
            throw BirthInputError.emptyYear
        }
        guard let m = monthText?.trimmingCharacters(in: .whitespacesAndNewlines), !m.isEmpty else {
            throw BirthInputError.emptyMonth
        }
        guard let d = dayText?.trimmingCharacters(in: .whitespacesAndNewlines), !d.isEmpty else {
            throw BirthInputError.emptyDay
        }
        
        // 숫자인지
        guard let year = Int(y), let month = Int(m), let day = Int(d) else {
            throw BirthInputError.notNumber
        }
        
        // 날짜 범위
        let nowYear = Calendar.current.component(.year, from: Date())
        guard (1900...nowYear).contains(year) else {
            throw BirthInputError.yearOutOfRange
        }
        guard (1...12).contains(month) else {
            throw BirthInputError.monthOutOfRange
        }
        guard (1...31).contains(day) else {
            throw BirthInputError.dayOutOfRange
        }
        
        // 실제로 존재하는 날짜인지
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        guard let date = formatter.date(from: "\(year)-\(month)-\(day)") else {
            throw BirthInputError.invalidDate
        }
        return date
    }
    
    // 에러메시지
    private func message(for error: Error) -> String {
        switch error {
        case BirthInputError.emptyYear:       return "년도를 입력해주세요."
        case BirthInputError.emptyMonth:      return "월을 입력해주세요."
        case BirthInputError.emptyDay:        return "일을 입력해주세요."
        case BirthInputError.notNumber:       return "숫자만 입력해주세요."
        case BirthInputError.yearOutOfRange:  return "년도의 범위를 확인해주세요."
        case BirthInputError.monthOutOfRange: return "1~12월 범위만 허용됩니다."
        case BirthInputError.dayOutOfRange:   return "1~31일 범위만 허용됩니다."
        case BirthInputError.invalidDate:     return "존재하지 않는 날짜입니다."
        default:                              return "알 수 없는 오류가 발생했습니다."
        }
    }
}
