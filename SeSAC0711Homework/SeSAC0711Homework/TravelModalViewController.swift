//
//  TravelModalViewController.swift
//  SeSAC0711Homework
//
//  Created by andev on 7/15/25.
//

import UIKit
import Kingfisher

class TravelModalViewController: UIViewController {
    
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "관광지 화면"
        view.backgroundColor = .white
        
        setupUI()
        loadImage()
    }

    func setupUI() {
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = "카오산 로드"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center

        let subtitleLabel = UILabel()
        subtitleLabel.text = "낮과 밤 서로 다른 매력을 지닌 변화한 거리"
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .darkGray
        subtitleLabel.font = .systemFont(ofSize: 16)

        let button = UIButton(type: .system)
        button.setTitle("다른 관광지 보러 가기", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(popView), for: .touchUpInside)

        // 스택뷰
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, subtitleLabel, button])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 250),
            button.heightAnchor.constraint(equalToConstant: 44),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //Kingfisher로 이미지 로드
    func loadImage() {
        // 이미지 URL
        let testURLString = "https://images.unsplash.com/photo-1539498508910-091b5e859b1d?q=80&w=3250&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        if let url = URL(string: testURLString) {
            imageView.kf.setImage(with: url)
        } else {
            print("URL 생성 실패")
        }
    }

    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
}
