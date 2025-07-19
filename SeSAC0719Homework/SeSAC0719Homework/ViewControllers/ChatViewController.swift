//
//  ChatViewController.swift
//  SeSAC0719Homework
//
//  Created by andev on 7/19/25.
//

import UIKit

class ChatViewController: UIViewController {

    
    @IBOutlet var messageTextField: UITextField!
    
    var chatRoom: ChatRoom!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = chatRoom.chatroomName

    }
    


}
