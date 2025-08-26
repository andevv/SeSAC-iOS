//
//  SettingsCell.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/24/25.
//

import UIKit
import SnapKit

final class SettingsCell: UITableViewCell {
    static let reuseId = "SettingsCell"

    private let iconView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.tintColor = .label
        return v
    }()
    private let titleLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16, weight: .semibold)
        v.textColor = .label
        return v
    }()
    private let valueLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 15)
        v.textColor = .tertiaryLabel
        v.textAlignment = .right
        return v
    }()
    private let chevronView: UIImageView = {
        let v = UIImageView(image: UIImage(systemName: "chevron.right"))
        v.tintColor = .tertiaryLabel
        v.contentMode = .scaleAspectFit
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(valueLabel)
        contentView.addSubview(chevronView)

        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(22)
        }
        chevronView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(10); make.height.equalTo(16)
        }
        valueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(chevronView.snp.leading).offset(-8)
            make.width.lessThanOrEqualTo(140)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(14)
            make.trailing.lessThanOrEqualTo(valueLabel.snp.leading).offset(-8)
            make.centerY.equalToSuperview()
        }
        accessoryType = .none
        selectionStyle = .default
        backgroundColor = .secondarySystemGroupedBackground
        contentView.backgroundColor = .secondarySystemGroupedBackground
    }
    required init?(coder: NSCoder) { fatalError() }

    func bind(_ vm: SettingsRowViewModel) {
        iconView.image = UIImage(systemName: vm.systemImage)
        titleLabel.text = vm.title
        valueLabel.text = vm.value
        chevronView.isHidden = !vm.showsChevron
    }
}
