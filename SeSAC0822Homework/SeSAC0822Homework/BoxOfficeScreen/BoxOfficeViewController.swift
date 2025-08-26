//
//  BoxOfficeViewController.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/25/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BoxOfficeViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private lazy var viewModel = BoxOfficeViewModel(apiKey: movieAPIKey)

    // UI
    private let tableView = UITableView()
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "yyyyMMdd"
        return sb
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }

    private func configureUI() {
        navigationItem.titleView = searchBar

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func bind() {
        searchBar.rx.searchButtonClicked
            .bind(with: self) { owner, _ in owner.searchBar.resignFirstResponder() }
            .disposed(by: disposeBag)
        
        let input = BoxOfficeViewModel.Input(
            searchTap: searchBar.rx.searchButtonClicked,
            queryText: searchBar.rx.text.orEmpty
        )
        let output = viewModel.transform(input: input)

        output.titles
            .drive(tableView.rx.items(cellIdentifier: "cell",
                                      cellType: UITableViewCell.self)) { _, title, cell in
                cell.textLabel?.text = title
                cell.textLabel?.numberOfLines = 0
            }
            .disposed(by: disposeBag)

        output.showToast
            .bind(onNext: { [weak self] _ in
                self?.showToast("네트워크 통신에 실패했습니다.")
            })
            .disposed(by: disposeBag)
    }
}

private extension UIViewController {
    func showToast(_ message: String, duration: TimeInterval = 2.0) {
        let label = PaddingLabel()
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.alpha = 0

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            label.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])

        UIView.animate(withDuration: 0.25, animations: { label.alpha = 1 }) { _ in
            UIView.animate(withDuration: 0.25, delay: duration, options: [], animations: {
                label.alpha = 0
            }, completion: { _ in label.removeFromSuperview() })
        }
    }
}
