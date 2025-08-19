//
//  SimpleTableViewExampleViewController.swift
//  SeSAC0819Homework
//
//  Created by andev on 8/19/25.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SimpleTableViewExampleViewController: UIViewController {
    
    private let tableView = UITableView()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Simple Table View Example"
        
        configureHierarchy()
        configureLayout()
        configureTable()
        bind()
    }
    
    private func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func configureTable() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
    }
    
    private func bind() {
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        
        // 데이터 바인딩
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
                cell.accessoryType = .detailDisclosureButton
            }
            .disposed(by: disposeBag)
        
        // 셀 탭 시 alert
        tableView.rx.modelSelected(String.self)
            .subscribe(with: self) { owner, value in
                print("Cell Tapped")
                owner.presentAlert(title: "Tapped", message: value)
            }
            .disposed(by: disposeBag)
        
        // 액세서리 버튼
        tableView.rx.itemAccessoryButtonTapped
            .subscribe(with: self) { owner, indexPath in
                print("Accessory Tapped")
                owner.presentAlert(title: "Detail", message: "Tapped Detail @ \(indexPath.section), \(indexPath.row)")
            }
            .disposed(by: disposeBag)
    }
    
}

extension UIViewController {
    func presentAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}
