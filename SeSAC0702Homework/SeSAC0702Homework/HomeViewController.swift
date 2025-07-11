//
//  HomeViewController.swift
//  SeSAC0702Homework
//
//  Created by andev on 7/2/25.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var trendingContentsLabel: UILabel!
    @IBOutlet var tagLabel: UILabel!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var firstImageView: UIImageView!
    @IBOutlet var secondImageView: UIImageView!
    @IBOutlet var thirdImageView: UIImageView!
    @IBOutlet var top10ImageView: UIImageView!
    @IBOutlet var logoImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageViewCornerRadius(mainImageView)
        imageViewCornerRadius(firstImageView, cr: 5)
        imageViewCornerRadius(secondImageView, cr: 5)
        imageViewCornerRadius(thirdImageView, cr: 5)
        
        designMainImageView()
        designTagLabel()
        designSaveButton()
        
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        let imageNames = ["콘크리트유토피아", "어벤져스엔드게임", "암살", "알라딘", "극한직업"]
        
        mainImageView.image = UIImage(named: imageNames.randomElement()!)
        firstImageView.image = UIImage(named: imageNames.randomElement()!)
        secondImageView.image = UIImage(named: imageNames.randomElement()!)
        thirdImageView.image = UIImage(named: imageNames.randomElement()!)
        
        top10ImageView.isHidden = Bool.random()
        logoImageView.isHidden = Bool.random()
    }
    
    
    func imageViewCornerRadius(_ imageView: UIImageView, cr cornerRadius: Int = 10) {
        imageView.layer.cornerRadius = CGFloat(cornerRadius)
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.layer.borderWidth = 0.8
        
    }
    
    func designMainImageView() {
        mainImageView.alpha = 0.7
    }

    func designTagLabel() {
        tagLabel.font = .systemFont(ofSize: 15)
        tagLabel.textAlignment = NSTextAlignment.center
    }
    
    func designSaveButton() {
        saveButton.layer.cornerRadius = 5
        saveButton.clipsToBounds = true
        saveButton.backgroundColor = .darkGray
        saveButton.tintColor = .white
        saveButton.titleLabel?.font = .systemFont(ofSize: 13)
        saveButton.titleLabel?.textAlignment = .center
    }


}
