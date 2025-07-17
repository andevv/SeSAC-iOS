//
//  SecondFamousViewController.swift
//  SeSAC0711Homework
//
//  Created by andev on 7/17/25.
//

import UIKit
import Kingfisher

class SecondFamousViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDataSourcePrefetching {
    
    
    @IBOutlet var mySearchBar: UISearchBar!
    @IBOutlet var mySegmentedControl: UISegmentedControl!
    @IBOutlet var myCollectionView: UICollectionView!
    
    let cityList = CityInfo().city
    var filteredList: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //전체 데이터
        filteredList = cityList
        
        //XIB
        let xib = UINib(nibName: "SecondFamousCollectionViewCell", bundle: nil)
        
        myCollectionView.register(xib, forCellWithReuseIdentifier: "SecondFamousCollectionViewCell")
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        mySearchBar.delegate = self
        myCollectionView.prefetchDataSource = self
        
        //레이아웃 설정
        let layout = UICollectionViewFlowLayout()
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = (deviceWidth - (16 * 3)) / 2
        
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.4)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        
        myCollectionView.collectionViewLayout = layout
        
        // 세그먼트 값 변경 시 액션
        mySegmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        
        let city = filteredList[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondFamousCollectionViewCell", for: indexPath) as! SecondFamousCollectionViewCell
        
        cell.nameLabel.text = "\(city.city_name) | \(city.city_english_name)"
        cell.descriptionLabel.text = city.city_explain
        
        //이미지 최적화
        if let url = URL(string: city.city_image) {
            let processor = DownsamplingImageProcessor(size: cell.cityImageView.bounds.size)
            
            cell.cityImageView.kf.indicatorType = .activity
            cell.cityImageView.kf.setImage(
                with: url,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(0.2)),
                    .cacheOriginalImage,
                    .backgroundDecode, //이미지 백그라운드 디코딩
                ])
        } else {
            cell.cityImageView.image = UIImage(systemName: "photo")
        }
        
        //        if let url = URL(string: city.city_image) {
        //            cell.cityImageView.kf.setImage(with: url)
        //        } else {
        //            cell.cityImageView.image = UIImage(systemName: "photo")
        //        }
        
        return cell
    }
    
    @objc func segmentChanged() {
        filterCities()
    }
    
    //검색 함수
    func filterCities() {
        let keyword = mySearchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() ?? ""
        
        let baseList: [City]
        switch mySegmentedControl.selectedSegmentIndex {
        case 1: // 국내
            baseList = cityList.filter { $0.domestic_travel }
        case 2: // 해외
            baseList = cityList.filter { !$0.domestic_travel }
        default: // 전체
            baseList = cityList
        }
        
        if keyword.isEmpty {
            filteredList = baseList
        } else {
            filteredList = baseList.filter {
                $0.city_name.lowercased().contains(keyword) ||
                $0.city_english_name.lowercased().contains(keyword) ||
                $0.city_explain.lowercased().contains(keyword)
            }
        }
        
        myCollectionView.reloadData()
    }
    
    // 실시간 검색
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCities()
    }
    
    // 엔터(검색 버튼) 눌렀을 때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() //키보드 내리기
        filterCities()
    }
    
    //이미지 프리패칭
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap {
            URL(string: filteredList[$0.item].city_image)
        }
        ImagePrefetcher(urls: urls).start()
    }

}
