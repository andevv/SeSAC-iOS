//
//  NumbersViewController.swift
//  SeSAC0819Homework
//
//  Created by andev on 8/19/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NumbersViewController: UIViewController {
    
    private let viewModel = NumbersViewModel()
    
    private let container = UIView()
    
    private let number1: UITextField = {
        let tf = UITextField()
        tf.placeholder = "1"
        tf.textAlignment = .right
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.text = "1"
        return tf
    }()
    
    private let number2: UITextField = {
        let tf = UITextField()
        tf.placeholder = "2"
        tf.textAlignment = .right
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.text = "2"
        return tf
    }()
    
    private let number3: UITextField = {
        let tf = UITextField()
        tf.placeholder = "3"
        tf.textAlignment = .right
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.text = "3"
        return tf
    }()
    
    private let plusLabel: UILabel = {
        let lb = UILabel()
        lb.text = "+"
        lb.font = .systemFont(ofSize: 22, weight: .regular)
        return lb
    }()
    
    private let underline = UIView()
    private let resultLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 28, weight: .regular)
        lb.textAlignment = .right
        lb.text = "0"
        return lb
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Adding Numbers Example"
        
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    private func configureHierarchy() {
        view.addSubview(container)
        container.addSubview(number1)
        container.addSubview(number2)
        container.addSubview(plusLabel)
        container.addSubview(number3)
        container.addSubview(underline)
        container.addSubview(resultLabel)
        
        underline.backgroundColor = .separator
    }
    
    private func configureLayout() {
        container.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            make.centerY.equalTo(view.snp.centerY)
            make.width.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        plusLabel.snp.makeConstraints { make in
            make.leading.equalTo(container.snp.leading)
            make.centerY.equalTo(number3.snp.centerY)
        }
        
        number1.snp.makeConstraints { make in
            make.top.equalTo(container.snp.top)
            make.leading.equalTo(plusLabel.snp.trailing).offset(12)
            make.trailing.equalTo(container.snp.trailing)
            make.width.greaterThanOrEqualTo(160)
            make.height.equalTo(40)
        }
        
        number2.snp.makeConstraints { make in
            make.top.equalTo(number1.snp.bottom).offset(12)
            make.leading.trailing.height.equalTo(number1)
        }
        
        number3.snp.makeConstraints { make in
            make.top.equalTo(number2.snp.bottom).offset(12)
            make.leading.trailing.height.equalTo(number1)
        }
        
        underline.snp.makeConstraints { make in
            make.top.equalTo(number3.snp.bottom).offset(16)
            make.leading.equalTo(number1.snp.leading)
            make.trailing.equalTo(container.snp.trailing)
            make.height.equalTo(1)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(underline.snp.bottom).offset(8)
            make.trailing.equalTo(underline.snp.trailing)
            make.bottom.equalTo(container.snp.bottom)
        }
    }
    
    private func bind() {
        let input = NumbersViewModel.Input(
            number1: number1.rx.text, number2: number2.rx.text, number3: number3.rx.text)
        let output = viewModel.transform(input: input)
        
        output.result
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
