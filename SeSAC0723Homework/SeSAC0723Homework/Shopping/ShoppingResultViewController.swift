//
//  ShoppingResultViewController.swift
//  SeSAC0723Homework
//
//  Created by andev on 7/26/25.
//

import UIKit
import SnapKit

final class ShoppingResultViewController: UIViewController {
    
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
    
    private let recommendCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.itemSize = CGSize(width: 150, height: 200)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let viewModel: ShoppingResultViewModel
    private let refreshTrigger = Observable<Void?>(nil)
    private let changeSortTrigger = Observable<SortType?>(nil)
    private let loadRecommendedTrigger = Observable<Void?>(nil)
    private var output: ShoppingResultViewModel.Output!
    
    init(query: String) {
        self.viewModel = ShoppingResultViewModel(query: query)
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        setupUI()
        
        // transform
        let input: ShoppingResultViewModel.Input = .init(
            refresh: refreshTrigger,
            changeSort: changeSortTrigger,
            loadRecommended: loadRecommendedTrigger
        )
        output = viewModel.transform(input)
        
        bindOutput()
        
        // 최초 로드
        refreshTrigger.value = ()
        loadRecommendedTrigger.value = ()
        
    }
    
    private func bindOutput() {
        output.titleText.bind { [weak self] in
            self?.title = self?.output.titleText.value
        }
        output.totalText.bind { [weak self] in
            self?.totalLabel.text = self?.output.totalText.value
        }
        output.items.lazyBind { [weak self] in
            self?.collectionView.reloadData()
        }
        output.recommended.lazyBind { [weak self] in
            self?.recommendCollectionView.reloadData()
        }
        output.selectedSort.bind { [weak self] in
            guard let self = self else { return }
            for (idx, view) in self.sortStackView.arrangedSubviews.enumerated() {
                guard let button = view as? UIButton else { continue }
                let isSelected = SortType.allCases[idx] == self.output.selectedSort.value
                button.setTitleColor(isSelected ? .black : .white, for: .normal)
                button.backgroundColor = isSelected ? .white : .black
            }
        }
        output.errorMessage.lazyBind { [weak self] in
            guard let self = self, let msg = self.output.errorMessage.value else { return }
            self.showAlert(title: "안내", message: msg)
        }
    }
    
    private func setupUI() {
        view.addSubview(totalLabel)
        view.addSubview(sortStackView)
        view.addSubview(collectionView)
        view.addSubview(recommendCollectionView)
        
        totalLabel.textColor = .green
        totalLabel.font = .boldSystemFont(ofSize: 14)
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        sortStackView.axis = .horizontal
        sortStackView.spacing = 8
        sortStackView.distribution = .fillEqually
        
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
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(recommendCollectionView.snp.top).offset(-8)
        }
        
        recommendCollectionView.backgroundColor = .white
        recommendCollectionView.register(ShoppingResultCollectionViewCell.self, forCellWithReuseIdentifier: ShoppingResultCollectionViewCell.identifier)
        recommendCollectionView.dataSource = self
        recommendCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.height.equalTo(220)
        }
    }
    
    @objc private func sortButtonTapped(_ sender: UIButton) {
        let newSort = SortType.allCases[sender.tag]
        changeSortTrigger.value = newSort
    }
}

extension ShoppingResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === self.collectionView {
            return output.items.value.count
        } else {
            return output.recommended.value.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingResultCollectionViewCell.identifier, for: indexPath) as? ShoppingResultCollectionViewCell else {
            return UICollectionViewCell()
        }
        if collectionView === self.collectionView {
            cell.configure(with: output.items.value[indexPath.item])
        } else {
            cell.configure(with: output.recommended.value[indexPath.item])
        }
        return cell
    }
}
