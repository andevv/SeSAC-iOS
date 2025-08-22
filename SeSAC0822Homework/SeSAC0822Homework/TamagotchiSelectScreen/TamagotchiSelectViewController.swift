//
//  TamagotchiSelectViewController.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/22/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class TamagotchiSelectViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    private let disposeBag = DisposeBag()
    private let viewModel = TamagotchiSelectViewModel()
    
    // MARK: UI
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 16, right: 16)
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .clear
        v.alwaysBounceVertical = true
        v.register(TamagotchiCell.self, forCellWithReuseIdentifier: TamagotchiCell.reuseId)
        return v
    }()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        definesPresentationContext = true
        navigationController?.definesPresentationContext = true
        
        title = "다마고치 선택하기"
        configureHirearchy()
        configureLayout()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 3열 아이템 사이즈 계산
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let inset = layout.sectionInset
        let spacing = layout.minimumInteritemSpacing
        let width = collectionView.bounds.width - inset.left - inset.right - (spacing * 2)
        let itemSide = floor(width / 3.0)
        layout.itemSize = CGSize(width: itemSide, height: itemSide + 44) // 이미지 + 라벨
    }
    
    // MARK: Bind
    private func bind() {
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        let input = TamagotchiSelectViewModel.Input(
            itemSelected: collectionView.rx.itemSelected.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        // items -> cell
        output.items
            .drive(collectionView.rx.items(
                cellIdentifier: TamagotchiCell.reuseId,
                cellType: TamagotchiCell.self)
            ) { _, cellVM, cell in
                cell.bind(cellVM)
            }
            .disposed(by: disposeBag)
        
        // 선택 가능한 3개 셀 선택 시
        output.selectedAvailable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] tg in
                self?.presentDetail(tamagotchi: tg)
            })
            .disposed(by: disposeBag)
        
        // 준비중 셀 탭 시
        output.showInfo
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] message in
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // 상세화면 팝업 함수
    private func presentDetail(tamagotchi: Tamagotchi) {
        let vm = TamagotchiDetailPopupViewModel(tamagotchi: tamagotchi)
        let vc = TamagotchiDetailPopupViewController(viewModel: vm)
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.onStart = { [weak self] tg in
                // 저장
                TamagotchiStorage.shared.select(tg)
                // 메인으로 전환
                let main = TamagotchiMainViewController(viewModel: TamagotchiMainViewModel(tamagotchi: tg))
                self?.navigationController?.setViewControllers([main], animated: true)
            }
            present(vc, animated: false)
    }
    
    // MARK: Layout
    private func configureHirearchy() {
        view.addSubview(collectionView)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
