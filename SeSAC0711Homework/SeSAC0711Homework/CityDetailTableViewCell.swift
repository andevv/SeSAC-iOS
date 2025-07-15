//
//  CityDetailTableViewCell.swift
//  SeSAC0711Homework
//
//  Created by andev on 7/15/25.
//

import UIKit

class CityDetailTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var placeImageView: UIImageView!
    @IBOutlet var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        placeImageView.layer.cornerRadius = 8
        placeImageView.clipsToBounds = true
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.numberOfLines = 0
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        
    }


}
