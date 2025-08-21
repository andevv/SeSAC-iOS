//
//  SimpleValidationViewModel.swift
//  SeSAC0819Homework
//
//  Created by andev on 8/21/25.
//

import Foundation
import RxSwift
import RxCocoa

final class SimpleValidationViewModel {
    
    enum Constants {
        static let minimalUsernameLength = 5
        static let minimalPasswordLength = 5
    }
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let username: ControlProperty<String?>
        let password: ControlProperty<String?>
    }
    
    struct Output {
        let passwordEnabled: BehaviorSubject<Bool>
        let usernameErrorHidden: BehaviorSubject<Bool>
        let passwordErrorHidden: BehaviorSubject<Bool>
        let buttonEnabled: BehaviorSubject<Bool>
    }
    
    init() { }
    
    func transform(input: Input) -> Output {
        let passwordEnabled = BehaviorSubject<Bool>(value: false)
        let usernameErrorHidden = BehaviorSubject<Bool>(value: false)
        let passwordErrorHidden = BehaviorSubject<Bool>(value: false)
        let buttonEnabled = BehaviorSubject<Bool>(value: false)
        
        let usernameValid = input.username.orEmpty
            .map { $0.count >= Constants.minimalUsernameLength }
            .distinctUntilChanged()
        
        let passwordValid = input.password.orEmpty
            .map { $0.count >= Constants.minimalPasswordLength }
            .distinctUntilChanged()
        
        usernameValid
            .bind(to: passwordEnabled)
            .disposed(by: disposeBag)
        
        passwordValid
            .bind(to: passwordErrorHidden)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .distinctUntilChanged()
            .bind(to: buttonEnabled)
            .disposed(by: disposeBag)
        
        return Output(passwordEnabled: passwordEnabled,
                      usernameErrorHidden: usernameErrorHidden,
                      passwordErrorHidden: passwordErrorHidden,
                      buttonEnabled: passwordErrorHidden
        )
    }
}
