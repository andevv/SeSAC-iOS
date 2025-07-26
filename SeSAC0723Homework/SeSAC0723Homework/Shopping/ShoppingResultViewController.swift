//
//  ShoppingResultViewController.swift
//  SeSAC0723Homework
//
//  Created by andev on 7/26/25.
//

import UIKit
import SnapKit
import Alamofire

enum SortType: String, CaseIterable {
    case sim = "정확도"
    case date = "날짜순"
    case asc = "가격낮은순"

    var apiParameter: String {
        switch self {
        case .sim: return "sim"
        case .date: return "date"
        case .asc: return "asc"
        }
    }
}

class ShoppingResultViewController: UIViewController {
    
    var query: String = ""
    
    private var items: [ShoppingItem] = []
    private var selectedSort: SortType = .sim
    
    // API Key
    private let clientId = Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_ID") as? String ?? ""
    private let clientSecret = Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_SECRET") as? String ?? ""
    
    private let totalLabel = UILabel()
    private let sortStackView = UIStackView()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 8
        let width = (UIScreen.main.bounds.width - 40) / 2
        layout.itemSize = CGSize(width: width, height: 200)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        title = query
        
        // 타이틀 색상 흰색으로 설정
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        setupUI()
        fetchShoppingData()
    }
    
    private func setupUI() {
        view.addSubview(totalLabel)
        view.addSubview(sortStackView)
        view.addSubview(collectionView)

        totalLabel.textColor = .green
        totalLabel.font = .boldSystemFont(ofSize: 14)
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(16)
        }

        sortStackView.axis = .horizontal
        sortStackView.spacing = 8
        sortStackView.distribution = .fillEqually
        view.addSubview(sortStackView)

        sortStackView.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }

        SortType.allCases.enumerated().forEach { (index, sort) in
            let button = UIButton()
            button.setTitle(sort.rawValue, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 12)
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.white.cgColor
            button.tag = index
            button.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)

            let isSelected = sort == selectedSort
            button.setTitleColor(isSelected ? .black : .white, for: .normal)
            button.backgroundColor = isSelected ? .white : .black

            sortStackView.addArrangedSubview(button)
        }


        collectionView.backgroundColor = .black
        collectionView.register(
            ShoppingResultCollectionViewCell.self,
            forCellWithReuseIdentifier: ShoppingResultCollectionViewCell.identifier
        )
        collectionView.dataSource = self

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortStackView.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func sortButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        let newSort = SortType.allCases[index]
        selectedSort = newSort

        for (idx, view) in sortStackView.arrangedSubviews.enumerated() {
            guard let button = view as? UIButton else { continue }
            let isSelected = idx == index
            button.setTitleColor(isSelected ? .black : .white, for: .normal)
            button.backgroundColor = isSelected ? .white : .black
        }

        fetchShoppingData()
    }

    
    private func fetchShoppingData() {
        let url = "https://openapi.naver.com/v1/search/shop.json"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": clientId,
            "X-Naver-Client-Secret": clientSecret
        ]
        let parameters: Parameters = [
            "query": query,
            "display": 100,
            "sort": selectedSort.apiParameter
        ]

        AF.request(url, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: ShoppingResponse.self) { response in
                switch response.result {
                case .success(let data):
                    self.totalLabel.text = "\(data.total.formatted())개의 검색 결과"
                    self.items = data.items
                    self.collectionView.reloadData()
                case .failure(let error):
                    print("fail:", error)
                }
            }
    }
}

extension ShoppingResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ShoppingResultCollectionViewCell.identifier,
            for: indexPath
        ) as? ShoppingResultCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: items[indexPath.item])
        return cell
    }
}
