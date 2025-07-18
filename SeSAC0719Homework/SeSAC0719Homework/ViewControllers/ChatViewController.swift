//
//  ChatViewController.swift
//  SeSAC0719Homework
//
//  Created by andev on 7/19/25.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet var myTableView: UITableView!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var sendButton: UIButton!
    
    var chatRoom: ChatRoom!
    
    enum Identifier {
        static let chatTableViewCell = "ChatTableViewCell"
        static let MyChatTableViewCell = "MyChatTableViewCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = chatRoom.chatroomName
        
        configureTableView()
        configureMessageTextField()
        configureSendButton()

    }
    
    private func configureTableView() {
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.separatorStyle = .none
        
        myTableView.register(UINib(nibName: Identifier.chatTableViewCell, bundle: nil), forCellReuseIdentifier: Identifier.chatTableViewCell)
        myTableView.register(UINib(nibName: Identifier.MyChatTableViewCell, bundle: nil), forCellReuseIdentifier: Identifier.MyChatTableViewCell)
    }
    
    private func configureMessageTextField() {
        messageTextField.placeholder = "메시지를 입력하세요"
        messageTextField.layer.cornerRadius = 10
        messageTextField.clipsToBounds = true
        messageTextField.backgroundColor = .systemGray6
    }
    
    private func configureSendButton() {
        sendButton.tintColor = .lightGray
    }
}


extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoom.chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chatRoom.chatList[indexPath.row]
        
        if chat.user.name == ChatList.me.name {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.MyChatTableViewCell, for: indexPath) as! MyChatTableViewCell
            cell.configure(with: chat)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.chatTableViewCell, for: indexPath) as! ChatTableViewCell
            cell.configure(with: chat)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

