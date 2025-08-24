//
//  SettingsViewController.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SettingsViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel: SettingsViewModel

    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .systemGroupedBackground
        tv.separatorInset = UIEdgeInsets(top: 0, left: 60, bottom: 0, right: 16)
        tv.rowHeight = 56
        tv.tableFooterView = UIView()
        tv.contentInsetAdjustmentBehavior = .automatic
        return tv
    }()

    // inputs
    private let viewWillAppearSubject = PublishSubject<Void>()
    private let confirmResetSubject = PublishSubject<Void>()

    // MARK: - Init
    init(viewModel: SettingsViewModel = SettingsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        navigationItem.title = "설정"
        configureHierarchy()
        configureLayout()
        bind()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearSubject.onNext(())
    }

    private func configureHierarchy() {
        view.addSubview(tableView)
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseId)
    }
    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func bind() {
        let input = SettingsViewModel.Input(
            viewWillAppear: viewWillAppearSubject.asObservable(),
            selectRow: tableView.rx.itemSelected.asObservable(),
            confirmReset: confirmResetSubject.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.navTitle
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)

        output.rows
            .drive(tableView.rx.items(cellIdentifier: SettingsCell.reuseId, cellType: SettingsCell.self)) { _, vm, cell in
                cell.bind(vm)
            }
            .disposed(by: disposeBag)

        // 네비게이션
        output.routeEditName
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let vc = NameEditViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        output.routeChange
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let vc = TamagotchiSelectViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        // 초기화
        output.askResetConfirm
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.showResetAlert()
            })
            .disposed(by: disposeBag)

        output.didReset
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                // 선택 화면이 최초 화면이 되도록
                let select = TamagotchiSelectViewController()
                self?.navigationController?.setViewControllers([select], animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func showResetAlert() {
        let ac = UIAlertController(title: "데이터 초기화",
                                   message: "모든 데이터가 삭제되고 처음 상태로 돌아갑니다.",
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "취소", style: .cancel))
        ac.addAction(UIAlertAction(title: "초기화", style: .destructive, handler: { [weak self] _ in
            self?.confirmResetSubject.onNext(())
        }))
        present(ac, animated: true)
    }
}
