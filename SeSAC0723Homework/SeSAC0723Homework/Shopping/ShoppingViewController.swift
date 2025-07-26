//
//  ShoppingViewController.swift
//  SeSAC0723Homework
//
//  Created by andev on 7/26/25.
//

import UIKit

class ShoppingViewController: UIViewController {
    
    let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        // 타이틀 색상 흰색으로 설정
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        title = "쇼핑하기"
        configureSearchBar()
    }
    
    func configureSearchBar() {
        view.addSubview(searchBar)
        
        searchBar.delegate = self
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .white
        searchBar.barStyle = .black
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
    }
}

extension ShoppingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              query.count >= 2 else {
            print("검색어는 2글자 이상이어야 합니다.")
            return
        }
        
        searchBar.resignFirstResponder()
        
        let vc = ShoppingResultViewController()
        vc.query = query
        navigationController?.pushViewController(vc, animated: true)
    }
}
