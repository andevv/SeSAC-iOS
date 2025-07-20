//
//  ChatTableViewCell.swift
//  SeSAC0719Homework
//
//  Created by andev on 7/19/25.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureProfileImageView()
        configureNameLabel()
        configureMessageLabel()
        configureTimeLabel()
        
        
    }
    
    func configure(with chat: Chat) {
        profileImageView.image = UIImage(named: chat.user.image)
        nameLabel.text = chat.user.name
        messageLabel.text = chat.message
        timeLabel.text = DateFormatter.timeFormat(from: chat.date)
    }
    


    
    private func configureProfileImageView() {
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    private func configureNameLabel() {
        nameLabel.font = .systemFont(ofSize: 14)
    }
    
    private func configureMessageLabel() {
        messageLabel.font = .systemFont(ofSize: 12)
        messageLabel.numberOfLines = 0
        messageLabel.layer.borderWidth = 0.5
        messageLabel.layer.borderColor = UIColor.darkGray.cgColor
        messageLabel.layer.cornerRadius = 10
        messageLabel.clipsToBounds = true
    }
    
    private func configureTimeLabel() {
        timeLabel.font = .systemFont(ofSize: 10)
        timeLabel.textColor = .lightGray
    }
    
}
