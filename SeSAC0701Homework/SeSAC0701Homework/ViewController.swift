//
//  ViewController.swift
//  SeSAC0701Homework
//
//  Created by andev on 7/1/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var LogoLabel: UILabel!
    @IBOutlet var IdTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    @IBOutlet var NicknameTextField: UITextField!
    @IBOutlet var AddressTextField: UITextField!
    @IBOutlet var CodeTextField: UITextField!
    @IBOutlet var SignInButton: UIButton!
    @IBOutlet var ExtraInfoInputLabel: UILabel!
    @IBOutlet var OnOffSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        
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
    
    
    @IBAction func textFieldReturnPressed(_ sender: UITextField) {
    }
    
    @IBAction func textFieldReturnPressed2(_ sender: UITextField) {
    }
    
    @IBAction func textFieldReturnPressed3(_ sender: UITextField) {
    }
    
    @IBAction func textFieldReturnPressed4(_ sender: UITextField) {
    }
    
    @IBAction func textFieldReturnPressed5(_ sender: UITextField) {
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        print("아이디: \(IdTextField.text ?? "")")
        print("비밀번호: \(PasswordTextField.text ?? "")")
        print("닉네임: \(NicknameTextField.text ?? "")")
        print("주소: \(AddressTextField.text ?? "")")
        print("추천 코드: \(CodeTextField.text ?? "")")
    }
    
    
    func designLogoLabel() {
        
        LogoLabel.backgroundColor = UIColor.black
        LogoLabel.textColor = UIColor.red
        LogoLabel.text = "NFLIX"
        LogoLabel.numberOfLines = 1
        LogoLabel.font = UIFont.systemFont(ofSize: 50, weight: .bold)
        LogoLabel.textAlignment = NSTextAlignment.center
        //LogoLabel.alpha = 0.8
        //LogoLabel.layer.cornerRadius = 20
        //LogoLabel.layer.borderWidth = 3
        //LogoLabel.layer.borderColor = UIColor.red.cgColor
        //LogoLabel.clipsToBounds = true
        
    }
    
    func designIdTextField() {
        
        IdTextField.backgroundColor = .darkGray
        IdTextField.textColor = .white
        //IdTextField.placeholder = "이메일 주소 또는 전화번호"
        IdTextField.attributedPlaceholder = NSAttributedString(string: "이메일 주소 또는 전화번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        IdTextField.textAlignment = NSTextAlignment.center
        IdTextField.keyboardType = .emailAddress
        
    }
    
    func designPasswordTextField() {
        
        PasswordTextField.backgroundColor = .darkGray
        PasswordTextField.textColor = .white
        PasswordTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        PasswordTextField.textAlignment = NSTextAlignment.center
        PasswordTextField.isSecureTextEntry = true
        
    }
    
    func designNicknameTextField() {
        
        NicknameTextField.backgroundColor = .darkGray
        NicknameTextField.textColor = .white
        NicknameTextField.attributedPlaceholder = NSAttributedString(string: "닉네임", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        NicknameTextField.textAlignment = NSTextAlignment.center
        
    }
    
    func designAddressTextField() {
        
        AddressTextField.backgroundColor = .darkGray
        AddressTextField.textColor = .white
        AddressTextField.attributedPlaceholder = NSAttributedString(string: "위치", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        AddressTextField.textAlignment = NSTextAlignment.center
        
    }
    
    func designCodeTextField() {
        
        CodeTextField.backgroundColor = .darkGray
        CodeTextField.textColor = .white
        CodeTextField.attributedPlaceholder = NSAttributedString(string: "추천 코드 입력", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        CodeTextField.textAlignment = NSTextAlignment.center
        CodeTextField.keyboardType = .numberPad
        
    }
    
    func desinSignInButton() {
        
        SignInButton.backgroundColor = .white
        SignInButton.setTitle("회원가입", for: .normal)
        SignInButton.setTitleColor(.black, for: .normal)
        SignInButton.layer.cornerRadius = 6
        SignInButton.clipsToBounds = true
        
    }
    
    func designExtraInfoInputLabel() {
        
        ExtraInfoInputLabel.backgroundColor = .black
        ExtraInfoInputLabel.textColor = .white
        ExtraInfoInputLabel.text = "추가 정보 입력"
        ExtraInfoInputLabel.numberOfLines = 1

    }

    func designOnOffSwitch() {
        
        OnOffSwitch.onTintColor = .red
        OnOffSwitch.setOn(true, animated: true)
        OnOffSwitch.thumbTintColor = .white
        OnOffSwitch.backgroundColor = .white
        OnOffSwitch.clipsToBounds = true
        OnOffSwitch.layer.cornerRadius = 15
        
    }
    
}

