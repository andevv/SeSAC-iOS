//
//  TamagotchiMainViewController.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TamagotchiMainViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: TamagotchiMainViewModel
    
    // 네비게이션 우측 아이템
    private lazy var settingsItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: nil, action: nil)
        return item
    }()
    
    // 상단 구분선 (네비게이션바 아래)
    private let topSeparator: UIView = {
        let v = UIView()
        v.backgroundColor = .separator
        return v
    }()
    
    // 말풍선
    private let bubbleImageView: UIImageView = {
        let v = UIImageView(image: UIImage(named: "bubble"))
        v.contentMode = .scaleAspectFit
        return v
    }()
    private let bubbleTextLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 15)
        v.textColor = .label
        return v
    }()
    
    // 캐릭터
    private let circleContainer: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 90
        v.layer.masksToBounds = true
        v.backgroundColor = .clear
        return v
    }()
    private let characterImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }()
    private let namePill: InsetLabel = {
        let v = InsetLabel(insets: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 14, weight: .medium)
        v.layer.cornerRadius = 8
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.tertiaryLabel.cgColor
        v.clipsToBounds = true
        return v
    }()
    private let statusLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 14)
        v.textColor = .label
        return v
    }()
    
    // 구분선 + 입력창 + 버튼
    private let line1: UIView = {
        let v = UIView()
        v.backgroundColor = .separator
        return v
    }()
    private let feedField: UITextField = {
        let t = UITextField()
        t.keyboardType = .numberPad
        t.placeholder = "밥주세용"
        t.textAlignment = .center
        return t
    }()
    private let feedButton: UIButton = {
        let b = UIButton(type: .system)
        var cfg = UIButton.Configuration.plain()
        cfg.title = "밥먹기"
        cfg.image = UIImage(systemName: "leaf.fill")
        cfg.imagePlacement = .leading
        cfg.imagePadding = 6
        cfg.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        cfg.baseForegroundColor = .label
        b.configuration = cfg
        
        // 커스텀 테두리
        b.layer.cornerRadius = 10
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor.systemGray3.cgColor
        return b
    }()
    
    private let line2: UIView = {
        let v = UIView()
        v.backgroundColor = .separator
        return v
    }()
    private let drinkField: UITextField = {
        let t = UITextField()
        t.keyboardType = .numberPad
        t.placeholder = "물주세용"
        t.textAlignment = .center
        return t
    }()
    private let drinkButton: UIButton = {
        let b = UIButton(type: .system)
        var cfg = UIButton.Configuration.plain()
        cfg.title = "물먹기"
        cfg.image = UIImage(systemName: "drop.fill")
        cfg.imagePlacement = .leading
        cfg.imagePadding = 6
        cfg.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        cfg.baseForegroundColor = .label
        b.configuration = cfg
        
        b.layer.cornerRadius = 10
        b.layer.borderWidth = 1
        b.layer.borderColor = UIColor.systemGray3.cgColor
        return b
    }()
    
    // MARK: - Init
    init(viewModel: TamagotchiMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        
        // 네비게이션 세팅
        navigationItem.rightBarButtonItem = settingsItem
        navigationController?.navigationBar.prefersLargeTitles = false
        
        configureHierarchy()
        configureLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearSubject.onNext(())
    }
    
    // MARK: - Bind
    private let viewWillAppearSubject = PublishSubject<Void>()
    private func bind() {
        let input = TamagotchiMainViewModel.Input(
            viewWillAppear: viewWillAppearSubject.asObservable(),
            feedTap: feedButton.rx.tap.asObservable(),
            drinkTap: drinkButton.rx.tap.asObservable(),
            feedText: feedField.rx.text.asObservable(),
            drinkText: drinkField.rx.text.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        // 네비게이션바 타이틀 바인딩
        output.navTitle
            .drive(onNext: { [weak self] title in
                self?.navigationItem.title = title
            })
            .disposed(by: disposeBag)
        
        output.imageName
            .drive(onNext: { [weak self] name in
                self?.characterImageView.image = UIImage(named: name) ?? UIImage(named: "noImage")
            })
            .disposed(by: disposeBag)
        output.namePill.drive(namePill.rx.text).disposed(by: disposeBag)
        output.statusText.drive(statusLabel.rx.text).disposed(by: disposeBag)
        output.bubbleText.drive(bubbleTextLabel.rx.text).disposed(by: disposeBag)
        
        output.showAlert
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] msg in
                let a = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
                a.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(a, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.clearFeed
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.feedField.text = nil })
            .disposed(by: disposeBag)
        output.clearDrink
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in self?.drinkField.text = nil })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UI
    private func configureHierarchy() {
        view.addSubview(topSeparator)
        
        view.addSubview(bubbleImageView)
        bubbleImageView.addSubview(bubbleTextLabel)
        
        view.addSubview(circleContainer)
        circleContainer.addSubview(characterImageView)
        
        view.addSubview(namePill)
        view.addSubview(statusLabel)
        
        view.addSubview(line1)
        view.addSubview(feedField)
        view.addSubview(feedButton)
        
        view.addSubview(line2)
        view.addSubview(drinkField)
        view.addSubview(drinkButton)
    }
    
    private func configureLayout() {
        // 레이아웃 상수
        let hInset: CGFloat = 32
        let gapAfterStatus: CGFloat = 24
        let gapBetweenRows: CGFloat = 16
        let betweenFieldAndButton: CGFloat = 16
        let buttonWidth: CGFloat = 110
        let buttonHeight: CGFloat = 40
        let onePixel: CGFloat = 1

        // 상단 구분선
        topSeparator.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(onePixel)
        }

        // 말풍선
        bubbleImageView.snp.makeConstraints { make in
            make.top.equalTo(topSeparator.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(170)
        }
        bubbleTextLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28)
        }

        // 캐릭터
        circleContainer.snp.makeConstraints { make in
            make.top.equalTo(bubbleImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(260)
        }
        characterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        // 이름/상태
        namePill.snp.makeConstraints { make in
            make.top.equalTo(circleContainer.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(namePill.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        // 밥
        feedButton.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(gapAfterStatus)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(hInset)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        feedField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(hInset)
            make.trailing.equalTo(feedButton.snp.leading).offset(-betweenFieldAndButton)
            make.centerY.equalTo(feedButton.snp.centerY)
            make.height.greaterThanOrEqualTo(30)
        }
        line1.snp.makeConstraints { make in
            make.top.equalTo(feedField.snp.bottom).offset(1)
            make.leading.trailing.equalTo(feedField)
            make.height.equalTo(onePixel)
        }
        
        // 물
        drinkButton.snp.makeConstraints { make in
            make.top.equalTo(line1.snp.bottom).offset(gapBetweenRows)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(hInset)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        drinkField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(hInset)
            make.trailing.equalTo(drinkButton.snp.leading).offset(-betweenFieldAndButton)
            make.centerY.equalTo(drinkButton.snp.centerY)
            make.height.greaterThanOrEqualTo(30)
        }
        line2.snp.makeConstraints { make in
            make.top.equalTo(drinkField.snp.bottom).offset(1)
            make.leading.trailing.equalTo(drinkField)
            make.height.equalTo(onePixel)
        }
    }

}
