//
//  EmotionDiaryViewController.swift
//  SeSAC0702Homework
//
//  Created by andev on 7/2/25.
//

import UIKit

class EmotionDiaryViewController: UIViewController {
    
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    @IBOutlet var button6: UIButton!
    @IBOutlet var button7: UIButton!
    @IBOutlet var button8: UIButton!
    @IBOutlet var button9: UIButton!
    
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    @IBOutlet var label4: UILabel!
    @IBOutlet var label5: UILabel!
    @IBOutlet var label6: UILabel!
    @IBOutlet var label7: UILabel!
    @IBOutlet var label8: UILabel!
    @IBOutlet var label9: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        designAllButtons()
        designAllLabels()

    }
    
    @IBAction func emotionButtonTapped(_ sender: UIButton) {
        let labels = [label1, label2, label3, label4, label5, label6, label7, label8, label9]
        let emotions = ["행복해", "사랑해", "좋아해", "당황해", "속상해", "우울해", "심심해", "피곤해", "배고파"]
        
        let index = sender.tag - 1
        if index >= 0 && index < labels.count {
            labels[index]?.text = "\(emotions[index]) \(Int.random(in: 0...100))"
        }
    }
    
    
    // 공통 버튼 디자인
    func designAllButtons() {
        let buttons = [button1, button2, button3, button4, button5, button6, button7, button8, button9]
        
        for (index, button) in buttons.enumerated() {
            var config = UIButton.Configuration.plain()
            config.imagePlacement = .top
            config.imagePadding = 3
            
            let imageName = "mono_slime\(index + 1)"
            if let resizedImage = resizedImage(named: imageName, to: CGSize(width: 70, height: 70)) {
                config.image = resizedImage
            }
            button?.configuration = config
            button?.tag = index + 1 // 태그 설정 (1부터 9까지)
        }
    }
    
    // 공통 레이블 디자인
    func designAllLabels() {
        let labels = [label1, label2, label3, label4, label5, label6, label7, label8, label9]
        
        for label in labels {
            label?.textAlignment = .center
        }
    }
    
    
    // 이미지 리사이즈 함수
    func resizedImage(named name: String, to size: CGSize) -> UIImage? {
        guard let image = UIImage(named: name) else { return nil }
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resized
    }
}
