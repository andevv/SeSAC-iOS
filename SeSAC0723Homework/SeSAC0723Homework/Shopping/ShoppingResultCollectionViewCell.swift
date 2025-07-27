//
//  ShoppingResultCollectionViewCell.swift
//  SeSAC0723Homework
//
//  Created by andev on 7/26/25.
//

import UIKit
import SnapKit
import Kingfisher

class ShoppingResultCollectionViewCell: UICollectionViewCell {
    static let identifier = "ShoppingResultCollectionViewCell"
    
    let imageView = UIImageView()
    let mallLabel = UILabel()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    let likeButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .black
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(imageView)
        contentView.addSubview(mallLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        mallLabel.font = .systemFont(ofSize: 12)
        mallLabel.textColor = .lightGray

        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2

        priceLabel.font = .boldSystemFont(ofSize: 14)
        priceLabel.textColor = .white

        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .white

        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(120)
        }

        mallLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().inset(4)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().inset(4)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(4)
        }

        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.trailing.equalToSuperview().inset(4)
            make.width.height.equalTo(20)
        }
    }
    
    func configure(with item: ShoppingItem) {
        imageView.kf.setImage(with: URL(string: item.image))
        mallLabel.text = item.mallName
        titleLabel.text = item.title.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
        priceLabel.text = formatPrice(item.lprice)
    }
    
    private func formatPrice(_ priceString: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ko_KR")

        if let number = Int(priceString),
           let formatted = formatter.string(from: NSNumber(value: number)) {
            return "\(formatted)원"
        } else {
            return "\(priceString)원" // fallback
        }
    }

}
