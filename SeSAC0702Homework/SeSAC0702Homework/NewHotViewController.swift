//
//  NewHotViewController.swift
//  SeSAC0702Homework
//
//  Created by andev on 7/2/25.
//

import UIKit

class NewHotViewController: UIViewController {

    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var toBeButton: UIButton!
    @IBOutlet var popularContentsButton: UIButton!
    @IBOutlet var top10Button: UIButton!
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designSearchTextField()
        
        toBeButton.isSelected = true
        popularContentsButton.isSelected = false
        top10Button.isSelected = false
        
        designTopButton(toBeButton, title: "공개 예정", imageName: "blue")
        designTopButton(popularContentsButton, title: "모두의 인기 콘텐츠", imageName: "turquoise")
        designTopButton(top10Button, title: "TOP 10 시리즈", imageName: "pink")
        
        designToBeTitleLabel()
        designToBeSubLabel()
        
        
    }
    
    
    @IBAction func topButtonTapped(_ sender: UIButton) {
        // 선택 상태 초기화
        toBeButton.isSelected = false
        popularContentsButton.isSelected = false
        top10Button.isSelected = false
        
        // 클릭한 버튼만 선택
        sender.isSelected = true
        
        // 다시 스타일 적용
        designTopButton(toBeButton, title: "공개 예정", imageName: "blue")
        designTopButton(popularContentsButton, title: "모두의 인기 콘텐츠", imageName: "turquoise")
        designTopButton(top10Button, title: "TOP 10 시리즈", imageName: "pink")
        
        // 버튼에 따라 레이블 텍스트 변경
        if sender == toBeButton {
            titleLabel.text = "이런! 찾으시는 작품이 없습니다."
            subTitleLabel.text = "다른 영화, 시리즈, 배우, 감독 또는 장르를 검색해 보세요."
        } else if sender == popularContentsButton {
            titleLabel.text = "요즘 가장 인기 있는 콘텐츠!"
            subTitleLabel.text = "많은 사람들이 즐겨보고 있는 시리즈를 확인해 보세요."
        } else if sender == top10Button {
            titleLabel.text = "TOP 10 시리즈"
            subTitleLabel.text = "인기 순위를 기준으로 상위 콘텐츠를 보여드려요."
        }
    }
    
    
    
    func designSearchTextField() {
        searchTextField.backgroundColor = .darkGray
            searchTextField.attributedPlaceholder = NSAttributedString(
                string: "게임, 시리즈, 영화를 검색하세요...",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
        
        // 돋보기 이미지 설정
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        // 패딩용 뷰에 이미지 넣기
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        paddingView.addSubview(imageView)
        imageView.center = paddingView.center
        
        // 텍스트필드에 설정
        searchTextField.leftView = paddingView
        searchTextField.leftViewMode = .always
    }

    
    func designTopButton(_ button: UIButton, title: String, imageName: String) {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.title = title
        
        if let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal) {
            config.image = image
        }
        
        config.imagePlacement = .leading
        config.imagePadding = 6
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
        
        if button.isSelected {
            config.baseBackgroundColor = .white
            config.baseForegroundColor = .black
        } else {
            config.baseBackgroundColor = .black
            config.baseForegroundColor = .white
        }

        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            return outgoing
        }

        button.configuration = config
    }
    
    func designToBeTitleLabel() {
        titleLabel.text = "이런! 찾으시는 작품이 없습니다."
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }
    
    func designToBeSubLabel() {
        subTitleLabel.text = "다른 영화, 시리즈, 배우, 감독 또는 장르를 검색해 보세요."
        subTitleLabel.font = UIFont.systemFont(ofSize: 13)
        subTitleLabel.textColor = .lightGray
        subTitleLabel.textAlignment = .center
        subTitleLabel.numberOfLines = 0
    }


}
