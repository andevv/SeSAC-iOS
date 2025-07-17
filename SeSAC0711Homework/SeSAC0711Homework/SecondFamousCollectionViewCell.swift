//
//  SecondFamousCollectionViewCell.swift
//  SeSAC0711Homework
//
//  Created by andev on 7/17/25.
//

import UIKit

class SecondFamousCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var cityImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cityImageView.contentMode = .scaleAspectFill
        cityImageView.clipsToBounds = true
        cityImageView.layer.cornerRadius = cityImageView.frame.width / 1.2

        nameLabel.font = .boldSystemFont(ofSize: 15)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .darkGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.clipsToBounds = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityImageView.image = nil
    }


}
