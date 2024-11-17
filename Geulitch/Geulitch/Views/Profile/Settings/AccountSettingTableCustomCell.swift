//
//  AccountSettingTableCustomCell.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/25/24.
//

import UIKit
import SnapKit
import Then

class AccountSettingTableCustomCell: UITableViewCell {
    static let identifier = "AccountSettingTableCustomCell"
    
    private let iconImageView = UIImageView().then {
        $0.tintColor = UIColor.primaryTextColor
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 16, weight: .regular)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)

        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with title: String, iconName: String?) {
        titleLabel.text = title
        
        if let iconName = iconName {
            iconImageView.isHidden = false
            iconImageView.image = UIImage(systemName: iconName)
            
            titleLabel.snp.updateConstraints { make in
                make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            }
        } else {
            iconImageView.isHidden = true
            
            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(16)
            }
            
            titleLabel.textColor = UIColor.systemRed
            titleLabel.font = UIFont.notoSansKR(size: 16, weight: .semibold)
        }
    }
}
