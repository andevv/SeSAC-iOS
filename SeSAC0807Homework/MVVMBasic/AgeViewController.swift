//
//  AgeViewController.swift
//  MVVMBasic
//
//  Created by Finn on 8/7/25.
//

import UIKit

enum AgeInputError: Error {
    case empty
    case notNumber
    case outOfRange
}

class AgeViewController: UIViewController {
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "나이를 입력해주세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    let resultButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle( "클릭", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    let label: UILabel = {
        let label = UILabel()
        label.text = "여기에 결과를 보여주세요"
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        
        resultButton.addTarget(self, action: #selector(resultButtonTapped), for: .touchUpInside)
    }
    
    func configureHierarchy() {
        view.addSubview(textField)
        view.addSubview(resultButton)
        view.addSubview(label)
    }
    
    func configureLayout() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        resultButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(resultButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    func validateAgeInput(_ input: String?) throws(AgeInputError) -> Int {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func resultButtonTapped() {
        print(#function)
        view.endEditing(true)
        
        do {
            let age = try validateAgeInput(textField.text)
            label.text = "입력하신 나이는 \(age)세입니다."
            label.textColor = .label
        } catch let error {
            switch error {
            case AgeInputError.empty:
                label.text = "나이를 입력해주세요."
                label.textColor = .systemRed
            case AgeInputError.notNumber:
                label.text = "숫자만 입력해주세요."
                label.textColor = .systemRed
            case AgeInputError.outOfRange:
                label.text = "1~100 사이의 나이만 입력해주세요."
                label.textColor = .systemRed
            }
        }
    }
}
