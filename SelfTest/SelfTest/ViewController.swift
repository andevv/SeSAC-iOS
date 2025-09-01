//
//  ViewController.swift
//  SelfTest
//
//  Created by andev on 9/1/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    
    private let viewModel: ViewModel
    private let disposeBag = DisposeBag()
    
    private let myTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "여기에 입력"
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .whileEditing
        tf.textColor = .label
        tf.textAlignment = .center
        tf.layer.cornerRadius = 10
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.separator.cgColor
        return tf
    }()

    private let myLabel: UILabel = {
        let lb = UILabel()
        lb.text = "아무거나 입력해보세요!!"
        lb.font = .systemFont(ofSize: 18, weight: .regular)
        lb.textColor = .label
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    private func bind() {
        let input = ViewModel.Input(text: myTextField.rx.text)
        let output = viewModel.transform(input: input)
        
        output.resultText
            .drive(myLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(myTextField)
        view.addSubview(myLabel)
        
        myTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        myLabel.snp.makeConstraints { make in
            make.top.equalTo(myTextField.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}

