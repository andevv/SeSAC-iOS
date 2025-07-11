//
//  ViewController.swift
//  SeSAC0708Homework
//
//  Created by andev on 7/8/25.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var damaImageView: UIImageView!
    @IBOutlet var settingBtn: UIBarButtonItem!
    @IBOutlet var damaLabel: UILabel!
    @IBOutlet var damaNameLabel: UILabel!
    @IBOutlet var foodTextField: UITextField!
    @IBOutlet var waterTextField: UITextField!
    @IBOutlet var foodBtn: UIButton!
    @IBOutlet var waterBtn: UIButton!
    @IBOutlet var statusLabel: UILabel!
    
    var foodCount = 0
    var waterCount = 0
    var level = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTitleName()
        addUnderlineNavBar()
        self.navigationItem.backButtonTitle = "설정"
        designDamaNameLabel()
        designDamaLabel()
        designStatusLabel()
        designFoodBtn()
        designWaterBtn()
        designFoodTextField()
        designWaterTextField()
        addUnderline(to: foodTextField)
        addUnderline(to: waterTextField)
        
        damaLabel.text = randomTalk() //초기 메시지 보여줌
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //뷰 생명주기
        //뷰 WillAppear 상태마다 타이틀 값 가져와서 업데이트
        //랜덤 텍스트도 업데이트된 이름에 맞게 새로 생성
        updateTitleName()
        damaLabel.text = randomTalk()
    }

    @IBAction func foodBtnTapped(_ sender: UIButton) {
        damaLabel.text = foodTalk()
        
        let input = foodTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                let food = Int(input ?? "") ?? 1

                guard food <= 99 else {
                    showAlert("한 번에 먹을 수 있는 밥알은 99개까지입니다.")
                    return
                }

                foodCount += food
                calculateLevel()
    }
    
    @IBAction func waterBtnTapped(_ sender: UIButton) {
        damaLabel.text = waterTalk()
        
        let input = waterTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                let water = Int(input ?? "") ?? 1

                guard water <= 49 else {
                    showAlert("한 번에 먹을 수 있는 물방울은 49개까지입니다.")
                    return
                }

                waterCount += water
                calculateLevel()
    }
    
    //레벨 계산 및 statusLabel 업데이트
    func calculateLevel() {
        let levelValue = Double(foodCount) / 5.0 + Double(waterCount) / 2.0
        level = min(10, max(1, Int(levelValue)))
        
        statusLabel.text = "LV\(level) · 밥알 \(foodCount)개 · 물방울 \(waterCount)개"
        
        if level >= 2 && level <= 9 {
            updateDamaImage(for: level)
        }
    }
    
    //레벨별 이미지 변경 함수
    func updateDamaImage(for level: Int) {
        let levelLimit = min(9, max(1, level))
        let imgaeName = "2-\(levelLimit)"
        damaImageView.image = UIImage(named: imgaeName)
    }
    
    //네비게이션바 이름 업데이트
    func updateTitleName() {
        let name = getUserName()
        self.title = "\(name)님의 다마고치"
    }

    //현재 유저 이름 가져오는 함수
    func getUserName() -> String {
        let name = UserDefaults.standard.string(forKey: "userName") ?? "대장"
        return name
    }

    //일반 랜덤 텍스트
    func randomTalk() -> String {
        let name = getUserName()
        let messages = [
            "\(name)님, 반갑다.",
            "\(name)님! 물 줘.",
            "\(name)님, 밥 줘.",
            "반갑다. \(name)님!",
        ]
        return messages.randomElement()!
    }
    
    //밥먹기 랜덤 텍스트
    func foodTalk() -> String {
        let name = getUserName()
        let messages = [
            "\(name)님, 맛있다.",
            "\(name)님, 배부르다.",
        ]
        return messages.randomElement()!
    }

    //물먹기 랜덤 텍스트
    func waterTalk() -> String {
        let name = getUserName()
        let messages = [
            "\(name)님, 시원하다.",
            "\(name)님, 잘 마셨다."
        ]
        return messages.randomElement()!
    }
    
    //네비게이션바 밑줄 그리는 함수
    func addUnderlineNavBar() {
        let underline = UIView()
        underline.backgroundColor = .systemGray4
        underline.translatesAutoresizingMaskIntoConstraints = false
        
        if let navBar = self.navigationController?.navigationBar {
            navBar.addSubview(underline)
            NSLayoutConstraint.activate([
                underline.heightAnchor.constraint(equalToConstant: 1),
                underline.bottomAnchor.constraint(equalTo: navBar.bottomAnchor),
                underline.leadingAnchor.constraint(equalTo: navBar.leadingAnchor),
                underline.trailingAnchor.constraint(equalTo: navBar.trailingAnchor)
            ])
        }
    }
    
    func designDamaNameLabel() {
        damaNameLabel.text = "방실방실 다마고치"
        damaNameLabel.font = .systemFont(ofSize: 14)
        damaNameLabel.layer.cornerRadius = 5
        damaNameLabel.clipsToBounds = true
        damaNameLabel.textAlignment = .center
        damaNameLabel.layer.borderColor = UIColor.lightGray.cgColor
        damaNameLabel.layer.borderWidth = 0.5
    }
    
    func designDamaLabel() {
        damaLabel.textAlignment = .center
        damaLabel.numberOfLines = 0
    }
    
    func designStatusLabel() {
        statusLabel.font = .systemFont(ofSize: 12)
        statusLabel.text = "LV\(level) · 밥알 \(foodCount)개 · 물방울 \(waterCount)개"
        statusLabel.textAlignment = .center
    }
    
    func designFoodBtn() {
        foodBtn.setTitle("밥먹기", for: .normal)
        foodBtn.tintColor = .darkGray
        foodBtn.clipsToBounds = true
        foodBtn.layer.cornerRadius = 6
        foodBtn.layer.borderWidth = 0.3
    }
    
    func designWaterBtn() {
        waterBtn.setTitle("물먹기", for: .normal)
        waterBtn.tintColor = .darkGray
        waterBtn.clipsToBounds = true
        waterBtn.layer.cornerRadius = 6
        waterBtn.layer.borderWidth = 0.3
    }
    
    //텍스트필드 밑줄 그리는 함수
    func addUnderline(to textField: UITextField) {
        let underline = CALayer()
        underline.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 1)
        underline.backgroundColor = UIColor.lightGray.cgColor
        textField.borderStyle = .none
        textField.layer.addSublayer(underline)
    }
    
    func designFoodTextField() {
        foodTextField.placeholder = "밥주세용"
    }
    
    func designWaterTextField() {
        waterTextField.placeholder = "물주세용"
    }
    
    //경고창 표시
    func showAlert(_ message: String) {
            let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
}

