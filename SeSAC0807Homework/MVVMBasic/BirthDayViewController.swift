//
//  BirthDayViewController.swift
//  MVVMBasic
//
//  Created by Finn on 8/7/25.
//

import UIKit
import SnapKit

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

class BirthDayViewController: UIViewController {
    let yearTextField = GenericViewFactory.make(UITextField.self) {
        $0.placeholder = "년도를 입력해주세요"
        $0.borderStyle = .roundedRect
    }
    let yearLabel = GenericViewFactory.make(UILabel.self) {
        $0.text = "년"
    }
    let monthTextField = GenericViewFactory.make(UITextField.self) {
        $0.placeholder = "월을 입력해주세요"
        $0.borderStyle = .roundedRect
    }
    let monthLabel = GenericViewFactory.make(UILabel.self) {
        $0.text = "월"
    }
    let dayTextField = GenericViewFactory.make(UITextField.self) {
        $0.placeholder = "일을 입력해주세요"
        $0.borderStyle = .roundedRect
    }
    let dayLabel = GenericViewFactory.make(UILabel.self) {
        $0.text = "일"
    }
    let resultButton = GenericViewFactory.make(UIButton.self) {
        $0.backgroundColor = .systemBlue
        $0.setTitle("클릭", for: .normal)
        $0.layer.cornerRadius = 8
    }
    let resultLabel = GenericViewFactory.make(UILabel.self) {
        $0.text = "여기에 결과를 보여주세요"
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        
        resultButton.addTarget(self, action: #selector(resultButtonTapped), for: .touchUpInside)
    }
    
    func configureHierarchy() {
        view.addSubview(yearTextField)
        view.addSubview(yearLabel)
        view.addSubview(monthTextField)
        view.addSubview(monthLabel)
        view.addSubview(dayTextField)
        view.addSubview(dayLabel)
        view.addSubview(resultButton)
        view.addSubview(resultLabel)
    }
    
    func configureLayout() {
        yearTextField.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.centerY.equalTo(yearTextField)
            make.leading.equalTo(yearTextField.snp.trailing).offset(12)
        }
        
        monthTextField.snp.makeConstraints { make in
            make.top.equalTo(yearTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.centerY.equalTo(monthTextField)
            make.leading.equalTo(monthTextField.snp.trailing).offset(12)
        }
        
        dayTextField.snp.makeConstraints { make in
            make.top.equalTo(monthTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dayTextField)
            make.leading.equalTo(dayTextField.snp.trailing).offset(12)
        }
        
        resultButton.snp.makeConstraints { make in
            make.top.equalTo(dayTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(resultButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    func validateBirthInput(yearText: String?, monthText: String?, dayText: String?) throws(BirthInputError) -> Date {
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
        // 년도: 1900년 ~ 현재까지
        guard (1900...nowYear).contains(year) else {
            throw BirthInputError.yearOutOfRange
        }
        // 월
        guard (1...12).contains(month) else {
            throw BirthInputError.monthOutOfRange
        }
        // 일
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func resultButtonTapped() {
        view.endEditing(true)
        
        do {
            let birthDate = try validateBirthInput(yearText: yearTextField.text,
                                                   monthText: monthTextField.text,
                                                   dayText: dayTextField.text)
            let today = Calendar.current.startOfDay(for: Date())
            let birthDay = Calendar.current.startOfDay(for: birthDate)
            let days = Calendar.current.dateComponents([.day], from: birthDay, to: today).day ?? 0
            resultLabel.text = "D+\(days + 1) 일째 입니다."
            resultLabel.textColor = .label
        } catch let error {
            var message = ""
            switch error {
            case BirthInputError.emptyYear:
                message = "년도를 입력해주세요."
            case BirthInputError.emptyMonth:
                message = "월을 입력해주세요."
            case BirthInputError.emptyDay:
                message = "일을 입력해주세요."
            case BirthInputError.notNumber:
                message = "숫자만 입력해주세요."
            case BirthInputError.yearOutOfRange:
                message = "년도의 범위를 확인해주세요."
            case BirthInputError.monthOutOfRange:
                message = "1~12월 범위만 허용됩니다."
            case BirthInputError.dayOutOfRange:
                message = "1~31일 범위만 허용됩니다."
            case BirthInputError.invalidDate:
                message = "존재하지 않는 날짜입니다."
            }
            showAlert(message: message)
            resultLabel.text = ""
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "입력 오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
