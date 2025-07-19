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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureProfileImageView()
        configureNameLabel()
        configureMessageLabel()
        
        
    }
    
    func configure(with chat: Chat) {
        profileImageView.image = UIImage(named: chat.user.image)
        nameLabel.text = chat.user.name
        messageLabel.text = chat.message
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
    
}
