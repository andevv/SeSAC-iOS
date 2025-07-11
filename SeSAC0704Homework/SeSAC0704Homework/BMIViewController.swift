//
//  BMIViewController.swift
//  SeSAC7Week1Remind
//
//  Created by andev on 7/4/25.
//

import UIKit

class BMIViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    @IBOutlet var firstFieldLabel: UILabel!
    @IBOutlet var secondFieldLabel: UILabel!
    @IBOutlet var firstTextField: UITextField!
    @IBOutlet var secondTextField: UITextField!
    @IBOutlet var resultBtn: UIButton!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var randomBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designTitleLabel()
        designSubTitleLabel()
        designFieldLabel(firstFieldLabel)
        designFieldLabel(secondFieldLabel)
        firstFieldLabel.text = "키가 어떻게 되시나요?"
        secondFieldLabel.text = "몸무게는 어떻게 되시나요?"
        designTextField(firstTextField)
        designTextField(secondTextField)
        designResultBtn()
        designResultLabel()
        designRandomBtn()
        

    }
    
    
    @IBAction func resultBtnTapped(_ sender: UIButton) {
        //키, 몸무게 가져오기
        guard let heightText = firstTextField.text,
              let weightText = secondTextField.text,
              !heightText.isEmpty, !weightText.isEmpty,
              let height = Double(heightText),
              let weight = Double(weightText) else {
            showAlert(message: "키와 몸무게를 정확히 입력해주세요.")
            return
        }
        
        //비정상 범위 검사
        if height < 50 || height > 250 || weight < 10 || weight > 300 {
            showAlert(message: "입력된 값의 범위를 확인해주세요.")
            return
        }
        
        //BMI 계산
        let heightInMeter = height / 100
        let bmi = weight / (heightInMeter * heightInMeter)
        
        //결과 출력
        resultLabel.text = ("BMI 지수는 \(String(format: "%.1f", bmi))입니다.")
    }
    
    
    @IBAction func radomBtnTapped(_ sender: UIButton) {
        //키: 130~200, 몸무게: 40~120
        let randomHeight = Int.random(in: 130...200)
        let randomWeight = Int.random(in: 40...120)
        
        firstTextField.text = "\(randomHeight)"
        secondTextField.text = "\(randomWeight)"
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "입력 오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    
    func designTitleLabel() {
        titleLabel.text = "BMI Calculator"
        titleLabel.font = .boldSystemFont(ofSize: 25)
    }
    
    func designSubTitleLabel() {
        subTitleLabel.text = "당신의 BMI 지수를\n알려드릴게요."
        subTitleLabel.font = .systemFont(ofSize: 15)
        subTitleLabel.numberOfLines = 2
        
    }
    
    func designFieldLabel(_ fieldLabel :UILabel) {
        fieldLabel.font = .systemFont(ofSize: 12)
    }

    func designTextField(_ textField: UITextField) {
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.layer.borderWidth = 0.8
        textField.layer.borderColor = UIColor.blue.cgColor
    }
    
    func designResultBtn() {
        resultBtn.setTitle("결과 확인", for: .normal)
        resultBtn.setTitleColor(.white, for: .normal)
        resultBtn.backgroundColor = .purple
        resultBtn.layer.cornerRadius = 10
        resultBtn.layer.borderWidth = 0.8
        resultBtn.clipsToBounds = true
    }
    
    func designResultLabel() {
        resultLabel.text = ""
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 1
        resultLabel.font = .systemFont(ofSize: 12)
    }
    
    func designRandomBtn() {
        randomBtn.setTitle("랜덤으로 BMI 계산하기", for: .normal)
        randomBtn.setTitleColor(.lightGray, for: .normal)
        randomBtn.titleLabel?.font = .systemFont(ofSize: 10)
        randomBtn.contentHorizontalAlignment = .right
    }


}
