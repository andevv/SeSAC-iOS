//
//  TravelTalkCollectionViewCell.swift
//  SeSAC0719Homework
//
//  Created by andev on 7/19/25.
//

import UIKit

class TravelTalkCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var lastMessageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureProfileImageView()
        configureNameLabel()
        configureLastMessageLabel()
        configureDateLabel()
    }
    
    // MARK: - Configuration
    func configure(with room: ChatRoom) {
        profileImageView.image = UIImage(named: room.chatroomImage)
        nameLabel.text = room.chatroomName
        lastMessageLabel.text = room.chatList.last?.message
        dateLabel.text = formatDate(room.chatList.last?.date ?? "")
    }
    
    // MARK: - Utils
    func formatDate(_ string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = formatter.date(from: string) {
            formatter.dateFormat = "yy.MM.dd"
            return formatter.string(from: date)
        }
        return ""
    }
    
    // MARK: - UI Setup
    private func configureProfileImageView() {
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    private func configureNameLabel() {
        nameLabel.font = .boldSystemFont(ofSize: 15)
    }
    
    private func configureLastMessageLabel() {
        lastMessageLabel.font = .systemFont(ofSize: 12)
        lastMessageLabel.textColor = .darkGray
    }
    
    private func configureDateLabel() {
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .lightGray
    }

}
