//
//  TamagotchiSelectViewController.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TamagotchiSelectViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = TamagotchiSelectViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        configureHirearchy()
        configureLayout()
        bind()
    }
    
    private func bind() {
        
    }
    
    private func configureHirearchy() {
        
    }
    
    private func configureLayout() {
        
    }
    

}
