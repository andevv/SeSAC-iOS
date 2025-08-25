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

        let titles: Driver<[String]> = searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { Self.isValidDate($0) }
            .distinctUntilChanged()
            .flatMapLatest { date in
                CustomObservable.getBoxOffice(date: date, apiKey: movieAPIKey)
                    .map { list -> [String] in
                        let rows = list.map { "\($0.rank). \($0.movieNm)" }
                        return rows.isEmpty ? ["해당 날짜 결과 없음"] : rows
                    }
                    .catchAndReturn(["검색 실패"]) // 에러 시 스트림 유지
            }
            .asDriver(onErrorJustReturn: ["검색 실패"])

        titles
            .drive(tableView.rx.items(cellIdentifier: "cell",
                                      cellType: UITableViewCell.self)) { _, title, cell in
                cell.textLabel?.text = title
                cell.textLabel?.numberOfLines = 0
            }
            .disposed(by: disposeBag)
    }

    private static func isValidDate(_ s: String) -> Bool {
        // 간단 검증: 8자리 숫자
        s.range(of: #"^\d{8}$"#, options: .regularExpression) != nil
    }
}
