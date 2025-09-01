//
//  BaseViewModel.swift
//  SelfTest
//
//  Created by andev on 9/1/25.
//

import Foundation

protocol BaseViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
