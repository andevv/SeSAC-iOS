//
//  ShoppingResultViewController.swift
//  SeSAC0723Homework
//
//  Created by andev on 7/26/25.
//

import UIKit

class ShoppingResultViewController: UIViewController {
    
    var query: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        title = "\(query)"
        
        // 타이틀 색상 흰색으로 설정
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

    }
    



}
