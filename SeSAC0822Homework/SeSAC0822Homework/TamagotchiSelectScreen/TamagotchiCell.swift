//
//  TamagotchiCell.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/22/25.
//

import UIKit
import SnapKit

final class TamagotchiCell: UICollectionViewCell {
    static let reuseId = "TamagotchiCell"

    private let imageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.clipsToBounds = true
        v.backgroundColor = .clear
        return v
    }()

    private let nameLabel: InsetLabel = {
        let v = InsetLabel(insets: UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10))
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 13, weight: .medium)
        v.textColor = UIColor.label
        v.layer.cornerRadius = 6
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.tertiaryLabel.cgColor
        v.clipsToBounds = true
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        contentView.backgroundColor = .clear
    }
    required init?(coder: NSCoder) { fatalError() }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.bounds.width / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }

    private func configureHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
    }

    private func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(88)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }

    func bind(_ vm: TamagotchiCellViewModel) {
        imageView.image = UIImage(named: vm.imageName) ?? UIImage(named: "noImage")
        nameLabel.text = vm.title
        contentView.alpha = vm.isAvailable ? 1.0 : 0.8
    }
}
