//
//  LottoViewController.swift
//  SeSAC0723Homework
//
//  Created by andev on 7/23/25.
//

import UIKit
import SnapKit

// MARK: - 로또 공 색상 정의
enum BallColor {
    case yellow, blue, red, gray
    
    var uiColor: UIColor {
        switch self {
        case .yellow: return .systemYellow
        case .blue: return .systemBlue
        case .red: return .systemRed
        case .gray: return .lightGray
        }
    }
    
    static func color(for number: Int) -> BallColor {
        switch number {
        case 1...10: return .yellow
        case 11...20: return .blue
        case 21...30: return .red
        default: return .gray
        }
    }
}

// MARK: - 로또 공 UI 컴포넌트
class BallView: UIView {
    private let numberLabel = UILabel()
    
    init(number: Int) {
        super.init(frame: .zero)
        configure(number)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //공 내부 UI 구성
    private func configure(_ number: Int) {
        backgroundColor = BallColor.color(for: number).uiColor
        layer.cornerRadius = 20
        clipsToBounds = true
        
        numberLabel.text = "\(number)"
        numberLabel.textColor = .white
        numberLabel.font = .boldSystemFont(ofSize: 16)
        numberLabel.textAlignment = .center
        
        addSubview(numberLabel)
        numberLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.size.equalTo(40)
        }
    }
}

// MARK: - LottoViewController
class LottoViewController: UIViewController {
    
    // UI 요소
    private let roundTextField = UITextField()   //회차 선택 텍스트필드
    private let dateLabel = UILabel()    //추첨 날짜 표시 레이블
    private let resultLabel = UILabel()    //당첨결과 레이블
    private let numberStackView = UIStackView()    //로또 공 스택뷰
    private let bonusTitleLabel = UILabel()    //보너스 텍스트 레이블
    private let pickerView = UIPickerView()    //pickerView
    private let infoLabel = UILabel()    //당첨번호 안내 레이블
    
    //총 회차
    let totalRounds = Array(1...1181)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        layout()
        setResultLabel(round: 1)
        updateBalls()
    }
    
    // MARK: - UI 속성 설정
    private func setup() {
        roundTextField.borderStyle = .roundedRect
        roundTextField.textAlignment = .center
        roundTextField.font = .systemFont(ofSize: 20)
        roundTextField.inputView = pickerView
        roundTextField.text = "1"
        
        infoLabel.text = "당첨번호 안내"
        infoLabel.font = .systemFont(ofSize: 14)
        infoLabel.textColor = .black
        
        dateLabel.text = "2025-07-23 추첨"
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .darkGray
        dateLabel.textAlignment = .right
        
        resultLabel.font = .boldSystemFont(ofSize: 22)
        resultLabel.textAlignment = .center
        resultLabel.text = "1회 당첨결과"
        
        numberStackView.axis = .horizontal
        numberStackView.spacing = 8
        numberStackView.alignment = .center
        numberStackView.distribution = .equalSpacing
        
        bonusTitleLabel.text = "보너스"
        bonusTitleLabel.font = .systemFont(ofSize: 13)
        bonusTitleLabel.textColor = .darkGray
        bonusTitleLabel.textAlignment = .center
        
        // UI 요소들을 view에 추가
        [roundTextField, infoLabel, dateLabel, resultLabel, numberStackView, bonusTitleLabel].forEach {
            view.addSubview($0)
        }
        
        // pickerView 델리게이트 연결
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    // MARK: - 레이아웃 제약 설정
    private func layout() {
        roundTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(44)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(roundTextField.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(infoLabel)
            make.trailing.equalToSuperview().inset(20)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        numberStackView.snp.makeConstraints { make in
            make.top.equalTo(resultLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        bonusTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(numberStackView.snp.bottom).offset(4)
            make.trailing.equalTo(numberStackView.snp.trailing)
        }
    }
    
    // MARK: - resultLabel 텍스트 스타일 설정
    private func setResultLabel(round: Int) {
        let roundText = "\(round)회"
        let suffixText = " 당첨결과"
        let fullText = roundText + suffixText
        
        let attributed = NSMutableAttributedString(string: fullText)
        
        // 회차 부분
        let roundRange = NSRange(location: 0, length: roundText.count)
        attributed.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 22), range: roundRange)
        attributed.addAttribute(.foregroundColor, value: UIColor.systemYellow, range: roundRange)
        
        // 당첨결과 부분
        let suffixRange = NSRange(location: roundText.count, length: suffixText.count)
        attributed.addAttribute(.font, value: UIFont.systemFont(ofSize: 22), range: suffixRange)
        
        resultLabel.attributedText = attributed
    }
    
    // MARK: - 로또 공/보너스공 랜덤 생성 및 배치
    private func updateBalls() {
        numberStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let allNumbers = Array(1...45).shuffled()
        let winningNumbers = Array(allNumbers.prefix(6)).sorted()
        let bonusNumber = allNumbers[6]
        
        // 6개 공
        winningNumbers.map { BallView(number: $0) }
            .forEach { numberStackView.addArrangedSubview($0) }
        
        // + 기호
        let plus = UILabel()
        plus.text = "+"
        plus.font = .boldSystemFont(ofSize: 22)
        plus.textAlignment = .center
        plus.snp.makeConstraints {
            $0.width.equalTo(20)
        }
        numberStackView.addArrangedSubview(plus)
        
        // 보너스 공
        let bonus = BallView(number: bonusNumber)
        numberStackView.addArrangedSubview(bonus)
    }
}


// MARK: - PickerView Delegate, DataSource
extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        totalRounds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(totalRounds[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selected = totalRounds[row]
        roundTextField.text = "\(selected)"
        setResultLabel(round: selected)
        updateBalls()
    }
}

