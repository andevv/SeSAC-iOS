//
//  Observable.swift
//  MVVMBasic
//
//  Created by andev on 8/11/25.
//

import Foundation

final class Observable<Value> {
    
    // 값이 바뀔 때마다 호출되는 함수(리스너)를 저장할 변수
    private var listener: ((Value) -> Void)?

    // 관찰 대상 값
    var value: Value {
        didSet {
            // 값이 바뀌면 리스너 함수를 실행
            listener?(value)
        }
    }

    // 초기값을 설정
    init(_ value: Value) {
        self.value = value
    }

    // 뷰에서 값 변화를 구독하도록 만드는 함수
    // fireNow가 true면, 지금 저장된 value를 바로 한 번 실행해서 UI를 초기화해줌
    func bind(_ listener: ((Value) -> Void)?, fireNow: Bool = true) {
        self.listener = listener
        if fireNow {
            listener?(value)
        }
    }
}

