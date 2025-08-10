//
//  BMIViewController.swift
//  MVVMBasic
//
//  Created by Finn on 8/7/25.
//

import UIKit
import SnapKit

final class BMIViewController: UIViewController {
    
    private let viewModel = BMIViewModel()
    
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
        bindViewModel()
        
        resultButton.addTarget(self, action: #selector(resultButtonTapped), for: .touchUpInside)
    }
    
    // Bindings
    private func bindViewModel() {
        viewModel.onResultTextChange = { text in
            self.resultLabel.text = text
            if !text.isEmpty {
                self.resultLabel.textColor = .label
            }
        }
        viewModel.onEvent = { event in
            switch event {
            case .showAlert(let message):
                self.showAlert(message: message)
            }
        }
        // 초기값 반영
        resultLabel.text = viewModel.resultText
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func resultButtonTapped() {
        view.endEditing(true)
        viewModel.didTapResult(heightText: heightTextField.text,
                               weightText: weightTextField.text)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "입력 오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

}
