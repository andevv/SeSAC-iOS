//
//  TravelTableViewCell.swift
//  SeSAC0711Homework
//
//  Created by andev on 7/11/25.
//

import UIKit
import Kingfisher

class TravelTableViewCell: UITableViewCell {
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(#function)
        
        photoImageView.layer.cornerRadius = 12
        photoImageView.clipsToBounds = true
        
    }
    
    func configure(with magazine: Magazine) {
        titleLabel.text = magazine.title
        subtitleLabel.text = magazine.subtitle
        
        //날짜 형식 변환
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyMMdd"
        if let date = inputFormatter.date(from: magazine.date) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yy년 MM월 dd일"
            dateLabel.text = outputFormatter.string(from: date)
        } else {
            dateLabel.text = "날짜 오류"
        }
        
        //이미지 설정
        if let urlString = magazine.photo_image, let url = URL(string: urlString) {
            photoImageView.kf.setImage(with: url)
        } else {
            photoImageView.image = UIImage(systemName: "photo")
        }
    }
    
    
}
