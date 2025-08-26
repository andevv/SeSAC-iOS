//
//  NameEditViewController.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NameEditViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel: NameEditViewModel

    private let saveItem = UIBarButtonItem(title: "저장", style: .done, target: nil, action: nil)

    private let topSeparator: UIView = {
        let v = UIView()
        v.backgroundColor = .separator
        return v
    }()

    private let nameField: UITextField = {
        let t = UITextField()
        t.font = .systemFont(ofSize: 17)
        t.textColor = .label
        t.placeholder = ""
        t.clearButtonMode = .whileEditing
        t.returnKeyType = .done
        t.autocorrectionType = .no
        t.spellCheckingType = .no
        return t
    }()
    private let underline: UIView = {
        let v = UIView()
        v.backgroundColor = .separator
        return v
    }()

    // IO
    private let viewWillAppearSubject = PublishSubject<Void>()

    // MARK: - Init
    init(viewModel: NameEditViewModel = .init()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground

        navigationItem.rightBarButtonItem = saveItem

        configureHierarchy()
        configureLayout()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearSubject.onNext(())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameField.becomeFirstResponder()
    }

    // MARK: - UI
    private func configureHierarchy() {
        view.addSubview(topSeparator)
        view.addSubview(nameField)
        view.addSubview(underline)
    }

    private func configureLayout() {
        let onePx = 1.0 / UIScreen.main.scale

        topSeparator.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(onePx)
        }
        nameField.snp.makeConstraints { make in
            make.top.equalTo(topSeparator.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.greaterThanOrEqualTo(36)
        }
        underline.snp.makeConstraints { make in
            make.top.equalTo(nameField.snp.bottom).offset(8)
            make.leading.trailing.equalTo(nameField)
            make.height.equalTo(onePx)
        }
    }

    // MARK: - Bind
    private func bind() {
        let input = NameEditViewModel.Input(
            viewWillAppear: viewWillAppearSubject.asObservable(),
            nameText: nameField.rx.text.asObservable(),
            saveTap: saveItem.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.navTitle
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)

        output.currentName
            .drive(nameField.rx.text)
            .disposed(by: disposeBag)

        output.isSaveEnabled
            .drive(saveItem.rx.isEnabled)
            .disposed(by: disposeBag)

        output.didSave
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
