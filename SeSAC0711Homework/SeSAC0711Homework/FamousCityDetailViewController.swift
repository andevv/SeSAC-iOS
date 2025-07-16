//
//  FamousCityDetailViewController.swift
//  SeSAC0711Homework
//
//  Created by andev on 7/16/25.
//

import UIKit

class FamousCityDetailViewController: UIViewController {
    
    var city: City? //전달 받을 값
    
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        title = "도시 상세"

        setupUI()
        
        if let city = city {
            nameLabel.text = "\(city.city_name) | \(city.city_english_name)"
            descriptionLabel.text = city.city_explain
        }
    }
    
    func setupUI() {
        nameLabel.font = .boldSystemFont(ofSize: 24)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .darkGray

        let stack = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    



}
