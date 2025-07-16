//
//  FamousCityTableViewCell.swift
//  SeSAC0711Homework
//
//  Created by andev on 7/16/25.
//

import UIKit
import Kingfisher

class FamousCityTableViewCell: UITableViewCell {

    @IBOutlet var cityImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var explainLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cityImageView.contentMode = .scaleAspectFill
        cityImageView.clipsToBounds = true
        cityImageView.layer.cornerRadius = 12
        cityImageView.layer.maskedCorners = [
            .layerMinXMinYCorner, // 좌상단
            .layerMaxXMaxYCorner  // 우하단
        ]
        
        nameLabel.textColor = .white
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textAlignment = .right
        nameLabel.numberOfLines = 0
        
        explainLabel.textColor = .white
        explainLabel.textAlignment = .left
        explainLabel.font = .systemFont(ofSize: 14)
        explainLabel.numberOfLines = 0
        explainLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        explainLabel.layer.cornerRadius = 12
        explainLabel.clipsToBounds = true
        explainLabel.layer.maskedCorners = [.layerMaxXMaxYCorner]
        
        selectionStyle = .none
        backgroundColor = .white
        
    }

    func configure(with city: City) {
        if let url = URL(string: city.city_image) {
            cityImageView.kf.setImage(with: url)
        } else {
            cityImageView.image = UIImage(systemName: "photo")
        }

        nameLabel.text = "\(city.city_name) | \(city.city_english_name)"
        explainLabel.text = city.city_explain
    }
}
