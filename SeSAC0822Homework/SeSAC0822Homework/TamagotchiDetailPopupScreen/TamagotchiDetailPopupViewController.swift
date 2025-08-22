//
//  TamagotchiDetailPopupViewController.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TamagotchiDetailPopupViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel: TamagotchiDetailPopupViewModel

    // 전체뷰
    private let dimView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        v.alpha = 1.0
        return v
    }()

    // 카드뷰
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .secondarySystemGroupedBackground
        v.layer.cornerRadius = 8
        v.layer.masksToBounds = true
        return v
    }()

    private let circleContainer: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 60
        v.layer.masksToBounds = true
        v.backgroundColor = .clear
        return v
    }()

    private let imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.backgroundColor = .clear
        return v
    }()

    private let nameLabel: InsetLabel = {
        let v = InsetLabel(insets: UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 14, weight: .medium)
        v.layer.cornerRadius = 8
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.tertiaryLabel.cgColor
        v.clipsToBounds = true
        v.textColor = .label
        return v
    }()

    private let separator: UIView = {
        let v = UIView()
        v.backgroundColor = .separator
        return v
    }()

    private let descLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 14)
        v.textColor = .label
        return v
    }()

    private let cancelButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("취소", for: .normal)
        b.setTitleColor(.systemGray, for: .normal)
        b.setTitleColor(UIColor.systemGray.withAlphaComponent(0.6), for: .highlighted)
        return b
    }()

    private let startButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("시작하기", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        b.setTitleColor(.systemGray, for: .normal)
        b.setTitleColor(UIColor.systemGray.withAlphaComponent(0.6), for: .highlighted)
        return b
    }()

    private let bottomDivider: UIView = {
        let v = UIView()
        v.backgroundColor = .separator
        return v
    }()
    private let verticalDivider: UIView = {
        let v = UIView()
        v.backgroundColor = .separator
        return v
    }()

    // MARK: - Init
    init(viewModel: TamagotchiDetailPopupViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        configureHierarchy()
        configureLayout()
        bind()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.05) { self.dimView.alpha = 1.0 }
    }

    private func bind() {
        let input = TamagotchiDetailPopupViewModel.Input(
            cancelTap: cancelButton.rx.tap.asObservable(),
            startTap: startButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.title.drive(nameLabel.rx.text).disposed(by: disposeBag)
        output.imageName
            .drive(onNext: { [weak self] imageName in
                self?.imageView.image = UIImage(named: imageName) ?? UIImage(named: "noImage")
            })
            .disposed(by: disposeBag)
        output.desc.drive(descLabel.rx.text).disposed(by: disposeBag)

        output.dismiss
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)

        output.start
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                // TODO: 메인화면으로 전환 로직 추가 예정
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - UI
    private func configureHierarchy() {
        view.addSubview(dimView)
        view.addSubview(cardView)
        cardView.addSubview(circleContainer)
        circleContainer.addSubview(imageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(separator)
        cardView.addSubview(descLabel)
        cardView.addSubview(bottomDivider)
        cardView.addSubview(verticalDivider)
        cardView.addSubview(cancelButton)
        cardView.addSubview(startButton)
    }

    private func configureLayout() {
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cardView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28)
        }
        circleContainer.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(circleContainer.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        separator.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        bottomDivider.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(bottomDivider.snp.bottom)
            make.leading.equalToSuperview()
            make.height.equalTo(52)
            make.bottom.equalToSuperview()
        }
        startButton.snp.makeConstraints { make in
            make.top.equalTo(bottomDivider.snp.bottom)
            make.trailing.equalToSuperview()
            make.leading.equalTo(cancelButton.snp.trailing)
            make.width.equalTo(cancelButton.snp.width)
            make.height.equalTo(cancelButton.snp.height)
            make.bottom.equalToSuperview()
        }
        verticalDivider.snp.makeConstraints { make in
            make.top.equalTo(bottomDivider.snp.bottom)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(1)
        }
    }
}
