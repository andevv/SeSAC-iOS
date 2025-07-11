//
//  SavedContentsViewController.swift
//  SeSAC0702Homework
//
//  Created by andev on 7/2/25.
//

import UIKit

class SavedContentsViewController: UIViewController {

    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var settingButton: UIButton!
    @IBOutlet var explorerButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        designToBeTitleLabel()
        designToBeSubLabel()
        designSettingButton()
        designExplorerButton()
        
        
        
    }
    
    func designToBeTitleLabel() {
        titleLabel.text = "\'나만의 자동 저장\' 기능"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
    }
    
    func designToBeSubLabel() {
        subTitleLabel.text = "취향에 맞는 영화와 시리즈를 자동으로 저장해 드립니다. \n디바이스에 언제나 시청할 콘텐츠가 준비되니 지루할 틈이 없어요."
        subTitleLabel.font = UIFont.systemFont(ofSize: 10)
        subTitleLabel.textColor = .lightGray
        subTitleLabel.textAlignment = .center
        subTitleLabel.numberOfLines = 0
    }
    
    func designSettingButton() {
        settingButton.setTitle("설정하기", for: .normal)
        settingButton.setTitleColor(.white, for: .normal)
        settingButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        settingButton.backgroundColor = UIColor(red: 0.25, green: 0.45, blue: 0.95, alpha: 1.0)
        settingButton.layer.cornerRadius = 6
        settingButton.clipsToBounds = true
    }
    
    func designExplorerButton() {
        explorerButton.setTitle("저장 가능한 콘텐츠 살펴보기", for: .normal)
        explorerButton.setTitleColor(.black, for: .normal)
        explorerButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        explorerButton.backgroundColor = .white
        explorerButton.layer.cornerRadius = 6
        explorerButton.clipsToBounds = true
    }


}
