//
//  WordCounterViewModel.swift
//  MVVMBasic
//
//  Created by andev on 8/9/25.
//

import Foundation

final class WordCounterViewModel {

    // 출력 상태 (라벨에 그대로 바인딩)
    let countText = Observable<String>("현재까지 0글자 작성중")

    // 입력 변경 시 호출
    func updateInput(_ text: String) {
        let count = text.count
        countText.value = "현재까지 \(count)글자 작성중"
    }
}
