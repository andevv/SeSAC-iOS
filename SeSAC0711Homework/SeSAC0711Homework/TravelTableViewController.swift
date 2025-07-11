//
//  TravelTableViewController.swift
//  SeSAC0711Homework
//
//  Created by andev on 7/11/25.
//

import UIKit

class TravelTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
//MARK: - 셀 커스터마이징
    
    //셀 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    //셀 디자인 및 데이터
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! TravelTableViewCell
        
        //cell.posterImageView.layer.cornerRadius = 10
        
        return cell
    }
    
    //셀 높이
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    
}
