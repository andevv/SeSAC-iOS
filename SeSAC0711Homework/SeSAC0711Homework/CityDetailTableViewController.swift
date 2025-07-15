//
//  CityDetailTableViewController.swift
//  SeSAC0711Homework
//
//  Created by andev on 7/15/25.
//

import UIKit
import Kingfisher

class CityDetailTableViewController: UITableViewController {
    
    let identifier = "CityDetailTableViewCell"
    let adIdentifier = "CityDetailAdTableViewCell"
    
    var travelList: [Travel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        travelList = TravelInfo().travel  // 광고 포함 전체 데이터
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        // XIB 등록
        let adNib = UINib(nibName: adIdentifier, bundle: nil)
        tableView.register(adNib, forCellReuseIdentifier: adIdentifier)

    }

    //셀 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return travelList.count
    }

    
    //셀 디자인 및 데이터 처리
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let travel = travelList[indexPath.row]
        
        if travel.ad {
            let cell = tableView.dequeueReusableCell(withIdentifier: adIdentifier, for: indexPath) as! CityDetailAdTableViewCell
            cell.adLabel.text = travel.title
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CityDetailTableViewCell
            configureCell(cell, with: travel, index: indexPath.row)
            return cell
        }
    }
    
    func configureCell(_ cell: CityDetailTableViewCell, with travel: Travel, index: Int) {
        
        cell.titleLabel.text = travel.title
        cell.subtitleLabel.text = travel.description ?? ""
        cell.likeButton.isSelected = travel.like ?? false
        cell.likeButton.tag = index
        
        // Kingfisher 이미지 로딩
        if let urlStr = travel.travel_image, let url = URL(string: urlStr) {
            cell.placeImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "photo"))
        } else {
            cell.placeImageView.image = UIImage(systemName: "photo")
        }
        
        // 좋아요 버튼 이벤트 연결
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc private func likeButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard travelList.indices.contains(index), travelList[index].ad == false else { return }

        let travel = travelList[index]
        let newLike = !(travel.like ?? false)

        // 새로운 Travel 객체로 대체 (값 타입이기 때문)
        travelList[index] = Travel(
            title: travel.title,
            description: travel.description,
            travel_image: travel.travel_image,
            grade: travel.grade,
            save: travel.save,
            like: newLike,
            ad: false
        )

        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
        
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
    


}
