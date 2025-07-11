//
//  EmotionDiaryViewController.swift
//  SeSAC0701Homework
//
//  Created by andev on 7/1/25.
//

import UIKit

class EmotionDiaryViewController: UIViewController {
    
    
    //9개 버튼
    @IBOutlet var Button1: UIButton!
    @IBOutlet var Button2: UIButton!
    @IBOutlet var Button3: UIButton!
    @IBOutlet var Button4: UIButton!
    @IBOutlet var Button5: UIButton!
    @IBOutlet var Button6: UIButton!
    @IBOutlet var Button7: UIButton!
    @IBOutlet var Button8: UIButton!
    @IBOutlet var Button9: UIButton!
    
    //9개 레이블
    @IBOutlet var Label1: UILabel!
    @IBOutlet var Label2: UILabel!
    @IBOutlet var Label3: UILabel!
    @IBOutlet var Label4: UILabel!
    @IBOutlet var Label5: UILabel!
    @IBOutlet var Label6: UILabel!
    @IBOutlet var Label7: UILabel!
    @IBOutlet var Label8: UILabel!
    @IBOutlet var Label9: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        
        designButton1()
        designButton2()
        designButton3()
        designButton4()
        designButton5()
        designButton6()
        designButton7()
        designButton8()
        designButton9()
        
        designAllLabels()
    }
    
    
    
    @IBAction func button1Tapped(_ sender: UIButton) {
        Label1.text = "행복해 \(Int.random(in: 0...100))"
    }
    
    @IBAction func button2Tapped(_ sender: UIButton) {
        Label2.text = "사랑해 \(Int.random(in: 0...100))"
    }
    
    @IBAction func button3Tapped(_ sender: UIButton) {
        Label3.text = "좋아해 \(Int.random(in: 0...100))"
    }
    
    @IBAction func button4Tapped(_ sender: UIButton) {
        Label4.text = "당황해 \(Int.random(in: 0...100))"
    }
    
    @IBAction func button5Tapped(_ sender: UIButton) {
        Label5.text = "속상해 \(Int.random(in: 0...100))"
    }
    
    @IBAction func button6Tapped(_ sender: UIButton) {
        Label6.text = "우울해 \(Int.random(in: 0...100))"
    }
    
    @IBAction func button7Tapped(_ sender: UIButton) {
        Label7.text = "심심해 \(Int.random(in: 0...100))"
    }
    
    @IBAction func button8Tapped(_ sender: UIButton) {
        Label8.text = "행복해\(Int.random(in: 0...100))"
    }
    
    @IBAction func button9Tapped(_ sender: UIButton) {
        Label9.text = "행복해 \(Int.random(in: 0...100))"
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

    func designButton1() {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.imagePadding = 3
        if let resizedImage = resizedImage(named: "mono_slime1", to: CGSize(width: 70, height: 70)) {
            config.image = resizedImage
        }
        Button1.configuration = config
    }

    func designButton2() {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.imagePadding = 3
        if let resizedImage = resizedImage(named: "mono_slime2", to: CGSize(width: 70, height: 70)) {
            config.image = resizedImage
        }
        Button2.configuration = config
    }

    func designButton3() {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.imagePadding = 3
        if let resizedImage = resizedImage(named: "mono_slime3", to: CGSize(width: 70, height: 70)) {
            config.image = resizedImage
        }
        Button3.configuration = config
    }

    func designButton4() {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.imagePadding = 3
        if let resizedImage = resizedImage(named: "mono_slime4", to: CGSize(width: 70, height: 70)) {
            config.image = resizedImage
        }
        Button4.configuration = config
    }

    func designButton5() {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.imagePadding = 3
        if let resizedImage = resizedImage(named: "mono_slime5", to: CGSize(width: 70, height: 70)) {
            config.image = resizedImage
        }
        Button5.configuration = config
    }

    func designButton6() {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.imagePadding = 3
        if let resizedImage = resizedImage(named: "mono_slime6", to: CGSize(width: 70, height: 70)) {
            config.image = resizedImage
        }
        Button6.configuration = config
    }

    func designButton7() {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.imagePadding = 3
        if let resizedImage = resizedImage(named: "mono_slime7", to: CGSize(width: 70, height: 70)) {
            config.image = resizedImage
        }
        Button7.configuration = config
    }

    func designButton8() {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.imagePadding = 3
        if let resizedImage = resizedImage(named: "mono_slime8", to: CGSize(width: 70, height: 70)) {
            config.image = resizedImage
        }
        Button8.configuration = config
    }

    func designButton9() {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.imagePadding = 3
        if let resizedImage = resizedImage(named: "mono_slime9", to: CGSize(width: 70, height: 70)) {
            config.image = resizedImage
        }
        Button9.configuration = config
    }
    
    
    func designAllLabels() {
        let labels = [Label1, Label2, Label3, Label4, Label5, Label6, Label7, Label8, Label9]
        for label in labels {
            label?.textAlignment = .center
        }
    }

}
