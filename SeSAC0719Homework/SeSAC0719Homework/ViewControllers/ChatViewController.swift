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
    
    let chatTableViewCellIdentifier = "ChatTableViewCell"
    let MyChatTableViewCellIdentifier = "MyChatTableViewCell"

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
        
        myTableView.register(UINib(nibName: chatTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: chatTableViewCellIdentifier)
        myTableView.register(UINib(nibName: MyChatTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: MyChatTableViewCellIdentifier)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCellIdentifier, for: indexPath) as! MyChatTableViewCell
            cell.configure(with: chat)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: chatTableViewCellIdentifier, for: indexPath) as! ChatTableViewCell
            cell.configure(with: chat)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

