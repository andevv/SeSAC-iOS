//
//  ViewController.swift
//  SeSAC0703Homework
//
//  Created by andev on 7/3/25.
//

//접근제어자
//responder chain
//변수 스코프

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var btn1: UIButton!
    @IBOutlet var btn2: UIButton!
    @IBOutlet var btn3: UIButton!
    @IBOutlet var btn4: UIButton!
    @IBOutlet var searchBtn: UIButton!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var tagBtns: [UIButton]!
    
    // 신조어 사전
    let newWords: [String: String] = [
        "윰차": "유명과 무명의 차이",
        "실매": "실제로 매력있음",
        "만반잘부": "만나서 반가워 잘 부탁해",
        "꾸안꾸": "꾸민 듯 안 꾸민 듯",
        "삼귀자": "연애를 시작하기 전 썸 단계"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        searchTextField.delegate = self
        
        designSearchBtn()
        designSearchTextField()
        designTagBtn(btn1)
        designTagBtn(btn2)
        designTagBtn(btn3)
        designTagBtn(btn4)
        designResultLabel()
        
        // 버튼 디자인 및 타이틀 설정
        let recommendedWords = ["윰차", "실매", "만반잘부", "꾸안꾸"]
        let buttons = [btn1, btn2, btn3, btn4]
        
        for (index, word) in recommendedWords.enumerated() {
            let button = buttons[index]
            button?.setTitle(word, for: .normal)
            designTagBtn(button!)
        }
        
    }
    
    //키보드 내리기
    @IBAction func keyBoardDismiss(_ sender: Any) {
        print(#function)
        view.endEditing(true)
    }
    
    //검색 버튼 클릭
    @IBAction func searchBtnClicked(_ sender: UIButton) {
        print(#function)
        doSearch()
        
    }
    
    //태그 버튼 클릭
    @IBAction func tagBtnClicked(_ sender: UIButton) {
        print(#function)
        guard let keyword = sender.currentTitle else { return }
        searchTextField.text = keyword
        doSearch()
    }
    
    
    func designSearchBtn() {
        print(#function)
        searchBtn.backgroundColor = .black
        searchBtn.setTitleColor(.white, for: .normal)
        searchBtn.tintColor = .white
        
    }
    
    func designSearchTextField() {
        print(#function)
        searchTextField.borderStyle = .bezel
        searchTextField.layer.borderColor = UIColor.black.cgColor
        searchTextField.layer.borderWidth = 0.9
        searchTextField.placeholder = "신조어를 검색해보세요..."
        searchTextField.returnKeyType = .search
        
    }
    
    func designTagBtn(_ TagBtn: UIButton) {
        print(#function)
        TagBtn.setTitleColor(.black, for: .normal)
        TagBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        TagBtn.layer.borderColor = UIColor.black.cgColor
        TagBtn.layer.borderWidth = 0.8
        TagBtn.layer.cornerRadius = 10
        TagBtn.clipsToBounds = true
    }
    
    func designResultLabel() {
        print(#function)
        resultLabel.textColor = .black
        resultLabel.numberOfLines = 1
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 20)
    }
    
    //검색 로직
    func doSearch() {
        //guard let을 통해 유효성 검사
        //실패 시 return으로 함수 종료
        guard let input = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !input.isEmpty else {
            resultLabel.text = "검색어를 입력하세요"
            return
        }
        
        //if let을 통해 딕셔너리에서 값을 안전하게 꺼냄
        if let result = newWords[input] {
            resultLabel.text = result
        } else {
            resultLabel.text = "검색 결과가 없습니다"
        }
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doSearch()
        textField.resignFirstResponder() //dismiss keyboard
        return true
    }
}
