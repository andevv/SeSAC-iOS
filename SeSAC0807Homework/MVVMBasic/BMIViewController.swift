//
//  BMIViewController.swift
//  MVVMBasic
//
//  Created by Finn on 8/7/25.
//

import UIKit
import SnapKit

enum BMIInputError: Error {
    case emptyHeight
    case emptyWeight
    case notNumber
    case heightOutOfRange
    case weightOutOfRange
}

class BMIViewController: UIViewController {
    let heightTextField = GenericViewFactory.make(UITextField.self) {
        $0.placeholder = "키를 입력해주세요"
        $0.borderStyle = .roundedRect
    }
    let weightTextField = GenericViewFactory.make(UITextField.self) {
        $0.placeholder = "몸무게를 입력해주세요"
        $0.borderStyle = .roundedRect
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
        view.addSubview(heightTextField)
        view.addSubview(weightTextField)
        view.addSubview(resultButton)
        view.addSubview(resultLabel)
    }
    
    func configureLayout() {
        heightTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        weightTextField.snp.makeConstraints { make in
            make.top.equalTo(heightTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        resultButton.snp.makeConstraints { make in
            make.top.equalTo(weightTextField.snp.bottom).offset(20)
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
            let (height, weight) = try validateBMIInput(heightInput: heightTextField.text, weightInput: weightTextField.text)
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
