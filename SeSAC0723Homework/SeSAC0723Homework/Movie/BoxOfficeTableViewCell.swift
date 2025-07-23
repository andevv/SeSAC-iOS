//
//  BoxOfficeTableViewCell.swift
//  SeSAC0723Homework
//
//  Created by andev on 7/23/25.
//

import UIKit

class BoxOfficeTableViewCell: UITableViewCell {

    // UI 요소 정의
    private let rankLabel = UILabel()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    
    // 셀 식별자
    static let identifier = "BoxOfficeTableViewCell"
    
    // 초기화
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 셀 스타일 구성
    private func setup() {
        backgroundColor = .clear
        
        // 순위 레이블
        rankLabel.textColor = .black
        rankLabel.font = .boldSystemFont(ofSize: 14)
        rankLabel.textAlignment = .center
        rankLabel.backgroundColor = .white
        rankLabel.layer.cornerRadius = 2
        rankLabel.clipsToBounds = true
        contentView.addSubview(rankLabel)
        
        // 영화 제목 레이블
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 14)
        contentView.addSubview(titleLabel)
        
        // 날짜 레이블
        dateLabel.textColor = .lightGray
        dateLabel.font = .systemFont(ofSize: 12)
        contentView.addSubview(dateLabel)
    }
    
    // 레이아웃 구성
    private func layout() {
        rankLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(rankLabel.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }

        dateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }
    
    // 셀 데이터 구성
    func configure(rank: Int, movie: Movie) {
        rankLabel.text = "\(rank)"
        titleLabel.text = movie.title
        dateLabel.text = formattedDate(movie.releaseDate)
    }
    
    // DateFormatter
    private func formattedDate(_ raw: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        if let date = formatter.date(from: raw) {
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
        return raw
    }

}
