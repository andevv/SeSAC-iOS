//
//  FamousCityTableViewController.swift
//  SeSAC0711Homework
//
//  Created by andev on 7/15/25.
//

import UIKit
import Kingfisher

class FamousCityTableViewController: UITableViewController {
    
    let cityList = CityInfo().city
    var filteredList: [City] = []

    // UI
    let searchTextField = UITextField()
    let segmentedControl = UISegmentedControl(items: ["전체", "국내", "해외"])


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        // 초기 데이터 설정
        filteredList = cityList

        // XIB 등록
        let nib = UINib(nibName: "FamousCityTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FamousCityTableViewCell")
        
        setupSegmentHeader()

    }



    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FamousCityTableViewCell", for: indexPath) as! FamousCityTableViewCell
        
        cell.configure(with: filteredList[indexPath.row])
        return cell
    }
    
    func setupSegmentHeader() {
        let headerHeight: CGFloat = 50
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerHeight))

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.frame = CGRect(x: 16, y: 10, width: tableView.frame.width - 32, height: 30)

        headerView.addSubview(segmentedControl)
        tableView.tableHeaderView = headerView
    }
    
}

