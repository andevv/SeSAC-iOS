//
//  WordCounterViewModel.swift
//  MVVMBasic
//
//  Created by andev on 8/9/25.
//

import Foundation

final class WordCounterViewModel {

    // Input
    var inputText: String = "" {
        didSet {
            let count = inputText.count
            countText = "현재까지 \(count)글자 작성중"
        }
    }

    // VM 내부 로직
    //private(set)은 외부에서 쓰기 불가, 내부에서 쓰기 가능하도록 하는 접근제어자
    private(set) var countText: String = "현재까지 0글자 작성중" {
        didSet { onCountTextChanged?(countText) }
    }

    // Output(Bindings)
    var onCountTextChanged: ((String) -> Void)?
}
