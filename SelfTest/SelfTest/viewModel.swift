//
//  viewModel.swift
//  SelfTest
//
//  Created by andev on 9/1/25.
//

import Foundation
import RxSwift
import RxCocoa

final class ViewModel: BaseViewModel {

    struct Input {
        let text: ControlProperty<String?>
    }
    
    struct Output {
        let resultText: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let result = input.text
            .orEmpty
            .map { $0.isEmpty ? "아무거나 입력해보세요" : $0 }
            .asDriver(onErrorJustReturn: "에러")
        
        return Output(resultText: result)
    }
}
