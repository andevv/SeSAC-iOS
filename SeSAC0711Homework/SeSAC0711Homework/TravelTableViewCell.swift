//
//  TravelTableViewCell.swift
//  SeSAC0711Homework
//
//  Created by andev on 7/11/25.
//

import UIKit

class TravelTableViewCell: UITableViewCell {
    
    @IBOutlet var posterImageView: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        print(#function)
        
        posterImageView.layer.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
