//
//  FamousCityViewController.swift
//  SeSAC0711Homework
//
//  Created by andev on 7/16/25.
//

import UIKit
import Kingfisher

class FamousCityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    let cityList = CityInfo().city
    var filteredList: [City] = []

    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "인기 도시"
        view.backgroundColor = .white
        
        filterSegmentedControl.selectedSegmentIndex = 0
        filterSegmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        setupTableView()
        updateFilteredList()
        
    }
    
    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            filterSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            filterSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterSegmentedControl.heightAnchor.constraint(equalToConstant: 32),
            
            tableView.topAnchor.constraint(equalTo: filterSegmentedControl.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])


        let nib = UINib(nibName: "FamousCityTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "FamousCityTableViewCell")

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FamousCityTableViewCell", for: indexPath) as! FamousCityTableViewCell
        
        let city = filteredList[indexPath.row]
        cell.configure(with: city)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "FamousCityDetailViewController") as? FamousCityDetailViewController {
            vc.city = filteredList[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        updateFilteredList()
        tableView.reloadData()
    }
    
    func updateFilteredList() {
        switch filterSegmentedControl.selectedSegmentIndex {
        case 0: // 전체
            filteredList = cityList
        case 1: // 국내
            filteredList = cityList.filter { $0.domestic_travel }
        case 2: // 해외
            filteredList = cityList.filter { !$0.domestic_travel }
        default:
            filteredList = cityList
        }
    }

}
