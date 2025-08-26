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
    private let viewModel = LottoViewModel()

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
        let input = LottoViewModel.Input(
            searchTap: inputField.rx.controlEvent(.editingDidEndOnExit),
            queryText: inputField.rx.text.orEmpty
        )
        let output = viewModel.transform(input: input)

        output.resultText
            .drive(resultLabel.rx.text)
            .disposed(by: disposeBag)

        output.showToast
            .bind(onNext: { [weak self] _ in
                self?.showToast("네트워크 통신에 실패했습니다.")
            })
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

final class PaddingLabel: UILabel {
    var inset = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
    override func drawText(in rect: CGRect) { super.drawText(in: rect.inset(by: inset)) }
    override var intrinsicContentSize: CGSize {
        let s = super.intrinsicContentSize
        return CGSize(width: s.width + inset.left + inset.right,
                      height: s.height + inset.top + inset.bottom)
    }
}
