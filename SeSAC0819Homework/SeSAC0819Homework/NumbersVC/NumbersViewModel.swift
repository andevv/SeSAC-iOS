//
//  NumbersViewModel.swift
//  SeSAC0819Homework
//
//  Created by andev on 8/21/25.
//

import Foundation
import RxSwift
import RxCocoa

final class NumbersViewModel {
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let number1: ControlProperty<String?>
        let number2: ControlProperty<String?>
        let number3: ControlProperty<String?>
    }
    
    struct Output {
        let result: BehaviorSubject<String>
        
    }
    
    init() { }
    
    func transform(input: Input) -> Output {
        
        let resultText = BehaviorSubject<String>(value: "")
        
        Observable
            .combineLatest(
                input.number1.orEmpty,
                input.number2.orEmpty,
                input.number3.orEmpty
            ) { textValue1, textValue2, textValue3 -> String in
                let sum = (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
                return String(sum)
            }
            .bind(to: resultText)
            .disposed(by: disposeBag)
        
        return Output(result: resultText)
    }
    
}
