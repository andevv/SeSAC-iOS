//
//  ShoppingTableViewController.swift
//  SeSAC0708Homework
//
//  Created by andev on 7/10/25.
//

import UIKit

class ShoppingTableViewController: UITableViewController {
    
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var addButton: UIButton!
    
    
    struct ShoppingItem {
        var title: String
    }
    
    
    var shoppingList: [ShoppingItem] = [
            ShoppingItem(title: "그립톡 구매하기"),
            ShoppingItem(title: "사이다 구매"),
            ShoppingItem(title: "아이패드 케이스 최저가 알아보기"),
            ShoppingItem(title: "양말")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "쇼핑"
    }
    
    // 추가 버튼 클릭 시
    @IBAction func addButtonTapped(_ sender: UIButton) {
        print(#function)
        guard let text = inputTextField.text, !text.isEmpty else { return }
        let newItem = ShoppingItem(title: text)
        shoppingList.append(newItem)
        print(shoppingList)
        inputTextField.text = ""
        tableView.reloadData()
    }
    
    // 셀 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(#function)
        return shoppingList.count
    }
    
    // 셀 디자인 및 데이터 처리
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as? ShoppingTableViewCell else {
            return UITableViewCell()
        }
        let item = shoppingList[indexPath.row]
        cell.titleLabel.text = item.title
        cell.titleLabel.font = .systemFont(ofSize: 14)
        
        return cell
    }
    
    // 옆으로 스와이프 삭제
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic) // 삭제 애니메이션
            //tableView.reloadData()
        }
    }
    
    // 셀 클릭 시 삭제
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        shoppingList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // 셀 높이
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(#function)
        return 50
    }
    
}
