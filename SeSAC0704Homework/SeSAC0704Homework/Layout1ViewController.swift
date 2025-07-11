//
//  Layout1ViewController.swift
//  SeSAC7Week1Remind
//
//  Created by andev on 7/6/25.
//

import UIKit

class Layout1ViewController: UIViewController {
    
    
    
    @IBOutlet var logoLabel: UILabel!
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var codeTextField: UITextField!
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var extraInfoBtn: UILabel!
    @IBOutlet var onOffSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        designLogoLabel()
        designIdTextField()
        designPasswordTextField()
        designNicknameTextField()
        designAddressTextField()
        designCodeTextField()
        desinSignInButton()
        designExtraInfoInputLabel()
        designOnOffSwitch()


    }
    

    
    func designLogoLabel() {
        
        logoLabel.backgroundColor = UIColor.black
        logoLabel.textColor = UIColor.red
        logoLabel.text = "NFLIX"
        logoLabel.numberOfLines = 1
        logoLabel.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        logoLabel.textAlignment = NSTextAlignment.center
        
    }
    
    func designIdTextField() {
        
        idTextField.backgroundColor = .darkGray
        idTextField.textColor = .white
        idTextField.attributedPlaceholder = NSAttributedString(string: "이메일 주소 또는 전화번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        idTextField.textAlignment = NSTextAlignment.center
        idTextField.keyboardType = .emailAddress
        
    }
    
    func designPasswordTextField() {
        
        passwordTextField.backgroundColor = .darkGray
        passwordTextField.textColor = .white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        passwordTextField.textAlignment = NSTextAlignment.center
        passwordTextField.isSecureTextEntry = true
        
    }
    
    func designNicknameTextField() {
        
        nicknameTextField.backgroundColor = .darkGray
        nicknameTextField.textColor = .white
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: "닉네임", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        nicknameTextField.textAlignment = NSTextAlignment.center
        
    }
    
    func designAddressTextField() {
        
        addressTextField.backgroundColor = .darkGray
        addressTextField.textColor = .white
        addressTextField.attributedPlaceholder = NSAttributedString(string: "위치", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        addressTextField.textAlignment = NSTextAlignment.center
        
    }
    
    func designCodeTextField() {
        
        codeTextField.backgroundColor = .darkGray
        codeTextField.textColor = .white
        codeTextField.attributedPlaceholder = NSAttributedString(string: "추천 코드 입력", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        codeTextField.textAlignment = NSTextAlignment.center
        codeTextField.keyboardType = .numberPad
        
    }
    
    func desinSignInButton() {
        
        signInBtn.backgroundColor = .white
        signInBtn.setTitle("회원가입", for: .normal)
        signInBtn.setTitleColor(.black, for: .normal)
        signInBtn.layer.cornerRadius = 6
        signInBtn.clipsToBounds = true
        
    }
    
    func designExtraInfoInputLabel() {
        
        extraInfoBtn.backgroundColor = .black
        extraInfoBtn.textColor = .white
        extraInfoBtn.text = "추가 정보 입력"
        extraInfoBtn.numberOfLines = 1

    }

    func designOnOffSwitch() {
        
        onOffSwitch.onTintColor = .red
        onOffSwitch.setOn(true, animated: true)
        onOffSwitch.thumbTintColor = .white
        onOffSwitch.backgroundColor = .white
        onOffSwitch.clipsToBounds = true
        onOffSwitch.layer.cornerRadius = 15
        
    }

}
