//
//  LottoViewController.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/25/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class LottoViewController: UIViewController {

    private let disposeBag = DisposeBag()

    // MARK: - UI
    private let inputField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "검색할 회차를 입력하세요"
        tf.borderStyle = .roundedRect
        tf.textAlignment = .center
        tf.returnKeyType = .search
        return tf
    }()

    private let resultLabel: UILabel = {
        let lb = UILabel()
        lb.text = "로또 번호가 여기에 표시됩니다"
        lb.textAlignment = .center
        lb.numberOfLines = 0
        lb.font = .systemFont(ofSize: 18, weight: .semibold)
        return lb
    }()

    private let stack = UIStackView()

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "로또"

        configureUI()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputField.becomeFirstResponder()
    }

    // MARK: - Bind
    private func bind() {
        let lottoText = inputField.rx.controlEvent(.editingDidEndOnExit)
            .withLatestFrom(inputField.rx.text.orEmpty)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty && Int($0) != nil } //숫자 검증
            .distinctUntilChanged()
            .flatMapLatest { query in
                CustomObservable.getLotto(query: query)
                    .map { lotto in
                        let nums = [lotto.drwtNo1, lotto.drwtNo2, lotto.drwtNo3,
                                    lotto.drwtNo4, lotto.drwtNo5, lotto.drwtNo6]
                        return nums.map(String.init).joined(separator: "  ") + "  +  \(lotto.bnusNo)"
                    }
                    .catchAndReturn("회차를 다시 확인해주세요.") //에러 시 스트림 유지할 수 있도록
            }
            .observe(on: MainScheduler.instance)

        // 결과 바인딩
        lottoText
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
    }

    // MARK: - Layout
    private func configureUI() {
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 16

        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.greaterThanOrEqualTo(view.safeAreaLayoutGuide).offset(24)
            make.trailing.lessThanOrEqualTo(view.safeAreaLayoutGuide).inset(24)
            make.width.lessThanOrEqualTo(360)
        }

        [inputField, resultLabel].forEach { stack.addArrangedSubview($0) }
        inputField.snp.makeConstraints { $0.height.equalTo(44) }
    }
}
