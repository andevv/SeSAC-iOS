//
//  TravelModalViewController.swift
//  SeSAC0711Homework
//
//  Created by andev on 7/15/25.
//

import UIKit
import Kingfisher

class TravelModalViewController: UIViewController {
    
    var travel: Travel? //전달 받을 값
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "관광지 화면"
        view.backgroundColor = .white
        
        setupUI()
        configureContent()
    }

    func setupUI() {
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        //titleLabel.text = "카오산 로드"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center

        //subtitleLabel.text = "낮과 밤 서로 다른 매력을 지닌 변화한 거리"
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .darkGray
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.numberOfLines = 0

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
    
    func configureContent() {
        guard let travel = travel else { return }

        if let urlStr = travel.travel_image, let url = URL(string: urlStr) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }

        titleLabel.text = travel.title
        subtitleLabel.text = travel.description ?? ""
    }

    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
}
