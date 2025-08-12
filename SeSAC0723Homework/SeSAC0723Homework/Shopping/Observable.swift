//
//  Observable.swift
//  SeSAC0723Homework
//
//  Created by andev on 8/12/25.
//

import Foundation

class Observable<T> {
    
    private var action: (() -> Void)?
    
    var value: T {
        didSet {
            print("Observable didSet")
            action?()
        }
    }
    
    init(_ value: T) {
        print("Observable Init")
        self.value = value
    }
    
    func bind(action: @escaping () -> Void) {
        print("Observable Bind")
        action()
        self.action = action
    }
    
    func lazyBind(action: @escaping () -> Void) {
        print("Observable lazyBind")
        self.action = action
    }
}
