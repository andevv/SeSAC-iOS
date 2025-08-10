//
//  BirthDayViewController.swift
//  MVVMBasic
//
//  Created by Finn on 8/7/25.
//

import UIKit
import SnapKit

final class BirthDayViewController: UIViewController {
    
    private let viewModel = BirthDayViewModel()
    
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
        bindViewModel()
        
        resultButton.addTarget(self, action: #selector(resultButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        // resultText가 바뀌면 라벨 업데이트 (didSet 트리거)
        viewModel.onResultTextChange = { text in
            self.resultLabel.text = text
            // 성공 시에는 label 컬러를 기본 컬러로
            if !text.isEmpty {
                self.resultLabel.textColor = .label
            }
        }
        
        // Alert
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func resultButtonTapped() {
        view.endEditing(true)
        
        viewModel.didTapResult(yearText: yearTextField.text,
                               monthText: monthTextField.text,
                               dayText: dayTextField.text)
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "입력 오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
