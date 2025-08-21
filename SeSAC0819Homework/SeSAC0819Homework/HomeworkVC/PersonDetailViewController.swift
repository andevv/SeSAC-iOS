//
//  PersonDetailViewController.swift
//  SeSAC0819Homework
//
//  Created by andev on 8/21/25.
//

import UIKit

class PersonDetailViewController: UIViewController {
    
    private let person: Person
    
    init(person: Person) {
        self.person = person
        super.init(nibName: nil, bundle: nil)
        self.title = person.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
    }
}
