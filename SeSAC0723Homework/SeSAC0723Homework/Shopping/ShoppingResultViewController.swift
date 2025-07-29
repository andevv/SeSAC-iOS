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
    
    // 페이지네이션 관련 프로퍼티
    private var page = 1
    private var isLoading = false //중복 로딩 방지
    private var hasMoreData = true // 마지막 페이지 여부
    private let displayCount = 30
    
    // API Key
    private let clientId = Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_ID") as? String ?? ""
    private let clientSecret = Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_SECRET") as? String ?? ""
    
    private let totalLabel = UILabel()
    private let sortStackView = UIStackView()
    private let collectionView: UICollectionView = {
        let spacing: CGFloat = 16
        let inset: CGFloat = 16
        let totalSpacing = inset * 2 + spacing
        let cellWidth = (UIScreen.main.bounds.width - totalSpacing) / 2
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        layout.itemSize = CGSize(width: cellWidth, height: 200)
        
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
        fetchShoppingData(reset: true)
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
        collectionView.delegate = self
        
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
        
        fetchShoppingData(reset: true)
    }
    
    private func fetchShoppingData(reset: Bool = false) {
        if reset {
            page = 1
            items = []
            hasMoreData = true
            collectionView.reloadData()
        }
        guard !isLoading, hasMoreData else { return }
        isLoading = true
        
        let start = (page - 1) * displayCount + 1
        
        // 1000건 제한 로직 (네이버 API 정책 때문에 최대 검색 수 제한있음)
        if start > 1000 {
            isLoading = false
            hasMoreData = false
            showLimitAlert()
            return
        }
        
        let url = "https://openapi.naver.com/v1/search/shop.json"
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": clientId,
            "X-Naver-Client-Secret": clientSecret
        ]
        let parameters: Parameters = [
            "query": query,
            "display": displayCount,
            "start": start,
            "sort": selectedSort.apiParameter
        ]
        
        AF.request(url, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: ShoppingResponse.self) { response in
                self.isLoading = false
                switch response.result {
                case .success(let data):
                    self.totalLabel.text = "\(data.total.formatted())개의 검색 결과"
                    if reset {
                        self.items = data.items
                    } else {
                        self.items.append(contentsOf: data.items)
                    }
                    self.collectionView.reloadData()
                    self.page += 1
                    
                    // 마지막 페이지인지 확인
                    if (start + data.items.count - 1) >= data.total {
                        self.hasMoreData = false
                    }
                case .failure(let error):
                    print("fail:", error)
                    
                    //실패 시 alert
                    self.showAlert(title: "네트워크 오류", message: "네트워크 상태를 확인해주세요.")
                    
                }
            }
    }
    
    private func showLimitAlert() {
        let alert = UIAlertController(
            title: "안내",
            message: "네이버 API 정책상 1000건 이후는 조회할 수 없습니다.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
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

extension ShoppingResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard !isLoading, hasMoreData else { return }
        
        if indexPath.item == items.count - 1 {
            fetchShoppingData()
        }
    }
}
