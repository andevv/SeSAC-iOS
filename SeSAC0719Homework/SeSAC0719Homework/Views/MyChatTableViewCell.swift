//
//  MyChatTableViewCell.swift
//  SeSAC0719Homework
//
//  Created by andev on 7/19/25.
//

import UIKit

class MyChatTableViewCell: UITableViewCell {
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureMessageLabel()
        configureTimeLabel()
    }

    func configure(with chat: Chat) {
        messageLabel.text = chat.message
        timeLabel.text = DateFormatter.timeFormat(from: chat.date)
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
    
    private func configureTimeLabel() {
        timeLabel.font = .systemFont(ofSize: 10)
        timeLabel.textColor = .lightGray
    }
    
}
