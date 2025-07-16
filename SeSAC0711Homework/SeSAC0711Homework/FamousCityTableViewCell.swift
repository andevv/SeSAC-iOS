//
//  FamousCityTableViewCell.swift
//  SeSAC0711Homework
//
//  Created by andev on 7/15/25.
//

import UIKit
import Kingfisher

class FamousCityTableViewCell: UITableViewCell {

    @IBOutlet var cityImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var englishLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cityImageView.contentMode = .scaleAspectFill
        cityImageView.clipsToBounds = true
    }
    
    func configure(with city: City) {
        titleLabel.text = city.city_name
        englishLabel.text = city.city_english_name
        descriptionLabel.text = city.city_explain

        if let url = URL(string: city.city_image) {
            cityImageView.kf.setImage(with: url)
        } else {
            cityImageView.image = UIImage(systemName: "photo")
        }
    }


    
}
