//
//  UserNameInputViewController.swift
//  SeSAC0708Homework
//
//  Created by andev on 7/8/25.
//

import UIKit

class UserNameInputViewController: UIViewController {

    @IBOutlet var saveBtn: UIBarButtonItem!
    @IBOutlet var userInputTextField: UITextField!
    
    enum UserDefaultsKey {
        static let userName = "userName"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .lightGray
        addUnderline(to: userInputTextField)
        loadCurrentName()
        
    }

    @IBAction func saveBtnTapped(_ sender: UIBarButtonItem) {
        view.endEditing(true) //키보드 내리기

        guard let newName = userInputTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              newName.count >= 2, newName.count <= 6 else {
            // 유효성 검사 실패
            showAlert("이름은 2글자 이상 6글자 이하로 설정해주세요.")
            return
        }
        
        UserDefaults.standard.set(newName, forKey: UserDefaultsKey.userName)
        navigationController?.popViewController(animated: true)

    }
    
    func addUnderline(to textField: UITextField) {
        let underline = CALayer()
        underline.frame = CGRect(x: 0, y: textField.frame.height - 1, width: textField.frame.width, height: 1)
        underline.backgroundColor = UIColor.lightGray.cgColor
        textField.borderStyle = .none
        textField.layer.addSublayer(underline)
    }
    
    func loadCurrentName() {
        let currentName = UserDefaults.standard.string(forKey: UserDefaultsKey.userName) ?? "대장"
        userInputTextField.text = currentName
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }


}
