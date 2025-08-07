//
//  GenericViewFactory.swift
//  MVVMBasic
//
//  Created by andev on 8/7/25.
//

import UIKit

final class GenericViewFactory {
    static func make<T: UIView>(_ type: T.Type, configure: ((T) -> Void)? = nil) -> T {
        let view = T()    //T 타입의 UIView 인스턴스 생성
        if let configure = configure {
            configure(view)    //configure가 있으면 해당 인스턴스 커스텀
        }
        return view
    }
}


