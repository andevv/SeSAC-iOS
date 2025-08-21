//
//  SimpleValidationViewController.swift
//  SeSAC0819Homework
//
//  Created by andev on 8/19/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SimpleValidationViewController: UIViewController {
    
    private let viewModel = SimpleValidationViewModel()

    private let usernameTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Username"
        lb.font = .systemFont(ofSize: 16, weight: .regular)
        return lb
    }()

    private let usernameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter username"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        return tf
    }()

    private let usernameErrorLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .systemRed
        lb.font = .systemFont(ofSize: 14, weight: .regular)
        lb.numberOfLines = 0
        lb.text = "Username has to be at least \(SimpleValidationViewModel.Constants.minimalUsernameLength) characters"
        return lb
    }()

    private let passwordTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Password"
        lb.font = .systemFont(ofSize: 16, weight: .regular)
        return lb
    }()

    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter password"
        tf.borderStyle = .roundedRect
        tf.isSecureTextEntry = true
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.isEnabled = false // username 유효 전에는 비활성화
        return tf
    }()

    private let passwordErrorLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .systemRed
        lb.font = .systemFont(ofSize: 14, weight: .regular)
        lb.numberOfLines = 0
        lb.text = "Password has to be at least \(SimpleValidationViewModel.Constants.minimalPasswordLength) characters"
        return lb
    }()

    private let doSomethingButton: UIButton = {
        let bt = UIButton(type: .system)
        bt.setTitle("Do something", for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        bt.backgroundColor = .systemGray4
        bt.layer.cornerRadius = 6
        bt.isEnabled = false
        return bt
    }()

    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Simple Validation Example"

        configureHierarchy()
        configureLayout()
        bind()
    }

    private func configureHierarchy() {
        view.addSubview(usernameTitleLabel)
        view.addSubview(usernameField)
        view.addSubview(usernameErrorLabel)
        view.addSubview(passwordTitleLabel)
        view.addSubview(passwordField)
        view.addSubview(passwordErrorLabel)
        view.addSubview(doSomethingButton)
    }

    private func configureLayout() {
        let guide = view.safeAreaLayoutGuide

        usernameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(guide.snp.top).offset(20)
            make.leading.equalTo(guide.snp.leading).offset(20)
            make.trailing.lessThanOrEqualTo(guide.snp.trailing).inset(20)
        }

        usernameField.snp.makeConstraints { make in
            make.top.equalTo(usernameTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(guide.snp.leading).offset(20)
            make.trailing.equalTo(guide.snp.trailing).inset(20)
            make.height.equalTo(40)
        }

        usernameErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(8)
            make.leading.trailing.equalTo(usernameField)
        }

        passwordTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameErrorLabel.snp.bottom).offset(20)
            make.leading.equalTo(usernameField.snp.leading)
            make.trailing.lessThanOrEqualTo(usernameField.snp.trailing)
        }

        passwordField.snp.makeConstraints { make in
            make.top.equalTo(passwordTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.height.equalTo(usernameField)
        }

        passwordErrorLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(8)
            make.leading.trailing.equalTo(usernameField)
        }

        doSomethingButton.snp.makeConstraints { make in
            make.top.equalTo(passwordErrorLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(usernameField)
            make.height.equalTo(48)
        }
    }

    private func bind() {
        let input = SimpleValidationViewModel.Input(username: usernameField.rx.text, password: passwordField.rx.text)
        let output = viewModel.transform(input: input)
        
        output.passwordEnabled
            .bind(to: passwordField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.usernameErrorHidden
            .bind(to: usernameErrorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.passwordErrorHidden
            .bind(to: passwordErrorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.buttonEnabled
            .bind(to: doSomethingButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.buttonEnabled
            .map { $0 ? UIColor.systemGreen : UIColor.systemGray4 }
            .bind(to: doSomethingButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        doSomethingButton.rx.tap
            .withLatestFrom(output.buttonEnabled)
            .filter { $0 }
            .subscribe(with: self) { owner, _ in
                owner.showAlert()
            }
            .disposed(by: disposeBag)
    }

    func showAlert() {
        let alert = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
