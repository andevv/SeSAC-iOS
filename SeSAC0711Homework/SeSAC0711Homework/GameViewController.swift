//
//  GameViewController.swift
//  SeSAC0711Homework
//
//  Created by andev on 7/13/25.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var numberTextField: UITextField!
    @IBOutlet var resultTextView: UITextView!
    @IBOutlet var clapCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UITextFieldDelegate 처리 객체 선언
        numberTextField.delegate = self
        resultTextView.isEditable = false

    }
    
    //엔터 키 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        calculate369Game()
        
        return true
    }
    
    //369 계산 로직
    func calculate369Game() {
        //입력 받은 값 Int로 변환
        guard let input = numberTextField.text,
              let max = Int(input), max > 0 else {
            //숫자가 아니거나 0이하인 경우
            resultTextView.text = "올바른 숫자를 입력해주세요."
            clapCountLabel.text = ""
            return
        }

        var resultText = "" //최종 출력 문자열
        var totalClap = 0 //총 박수 수

        for i in 1...max {
            //i를 문자열로 변환, 각 자리 수에 접근 가능하도록
            let numberStr = String(i)
            var clapStr = "" //박수로 변환된 문자열

            //숫자의 각 자리수 하나씩 확인
            for digit in numberStr {
                if digit == "3" || digit == "6" || digit == "9" {
                    clapStr += "👏"
                    totalClap += 1
                } else {
                    clapStr += String(digit)
                }
            }

            resultText += clapStr + (i < max ? ", " : "") //마지막 숫자에는 쉼표 안 붙이도록
        }

        resultTextView.text = resultText
        clapCountLabel.text = "숫자 \(max)까지 총 박수는 \(totalClap)번 입니다."
    }
}
