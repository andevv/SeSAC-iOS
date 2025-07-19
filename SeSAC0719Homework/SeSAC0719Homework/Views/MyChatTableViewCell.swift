//
//  MyChatTableViewCell.swift
//  SeSAC0719Homework
//
//  Created by andev on 7/19/25.
//

import UIKit

class MyChatTableViewCell: UITableViewCell {
    
    @IBOutlet var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureMessageLabel()
    }

    
    func configure(with chat: Chat) {
        messageLabel.text = chat.message
    }
    
    private func configureMessageLabel() {
        messageLabel.font = .systemFont(ofSize: 12)
        messageLabel.numberOfLines = 0
        messageLabel.layer.borderWidth = 0.5
        messageLabel.layer.borderColor = UIColor.darkGray.cgColor
        messageLabel.layer.cornerRadius = 10
        messageLabel.clipsToBounds = true
        messageLabel.backgroundColor = .systemGray5
        
    }
    
}
