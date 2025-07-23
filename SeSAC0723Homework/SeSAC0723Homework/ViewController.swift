//
//  ViewController.swift
//  SeSAC0723Homework
//
//  Created by andev on 7/23/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func lottoButtonTapped(_ sender: UIButton) {
        let vc = LottoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func BoxOfficeButtonTapped(_ sender: UIButton) {
        let vc = BoxOfficeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

