//
//  BaseViewModel.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/26/25.
//

import Foundation

protocol BaseViewModel {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
