//
//  BMIViewController.swift
//  MVVMBasic
//
//  Created by Finn on 8/7/25.
//

import UIKit

enum BMIInputError: Error {
    case emptyHeight
    case emptyWeight
    case notNumber
    case heightOutOfRange
    case weightOutOfRange
}

class BMIViewController: UIViewController {
    let heightTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "키를 입력해주세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    let ageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "몸무게를 입력해주세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    let resultButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("클릭", for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    let resultLabel: UILabel = {
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
        view.addSubview(heightTextField)
        view.addSubview(ageTextField)
        view.addSubview(resultButton)
        view.addSubview(resultLabel)
    }
    
    func configureLayout() {
        heightTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        ageTextField.snp.makeConstraints { make in
            make.top.equalTo(heightTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        resultButton.snp.makeConstraints { make in
            make.top.equalTo(ageTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(resultButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
    }
    
    func validateBMIInput(heightInput: String?, weightInput: String?) throws(BMIInputError) -> (Double, Double) {
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func resultButtonTapped() {
        view.endEditing(true)
        
        do {
            let (height, weight) = try validateBMIInput(heightInput: heightTextField.text, weightInput: ageTextField.text)
            let bmi = weight / ((height/100) * (height/100))
            resultLabel.text = String(format: "BMI: %.2f", bmi)
            resultLabel.textColor = .label
        } catch let error {
            var message = ""
            switch error {
            case BMIInputError.emptyHeight:
                message = "키를 입력해주세요."
            case BMIInputError.emptyWeight:
                message = "몸무게를 입력해주세요."
            case BMIInputError.notNumber:
                message = "숫자만 입력해주세요."
            case BMIInputError.heightOutOfRange:
                message = "키는 90~250cm 범위만 허용됩니다."
            case BMIInputError.weightOutOfRange:
                message = "몸무게는 20~200kg 범위만 허용됩니다."
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
