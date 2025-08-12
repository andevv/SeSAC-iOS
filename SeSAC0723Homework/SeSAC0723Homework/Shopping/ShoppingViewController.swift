//
//  ShoppingViewController.swift
//  SeSAC0723Homework
//
//  Created by andev on 7/26/25.
//

import UIKit
import SnapKit

final class ShoppingViewController: UIViewController {
    
    let searchBar = UISearchBar()
    private let viewModel = ShoppingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        title = "쇼핑하기"
        configureSearchBar()
        bindViewModel()
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
    
    // 바인딩 시점에 실행되면 안되기 때문에 lazy
    private func bindViewModel() {
        viewModel.alertMessage.lazyBind { [weak self] in
            guard let msg = self?.viewModel.alertMessage.value, let self = self, !msg.isEmpty else { return }
            self.showAlert(title: "검색어 오류", message: msg) { self.searchBar.text = "" }
        }
        viewModel.navigateQuery.lazyBind { [weak self] in
            guard let q = self?.viewModel.navigateQuery.value, let self = self else { return }
            let vc = ShoppingResultViewController(query: q)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ShoppingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.submit(searchBar.text) //VM에 값 전달
    }
}


extension UIViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in completion?() }
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
