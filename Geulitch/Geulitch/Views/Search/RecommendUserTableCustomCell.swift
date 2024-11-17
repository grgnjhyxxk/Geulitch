//
//  RecommendUserTableCustomCell.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 11/9/24.
//

import UIKit
import SnapKit
import Then
import AVKit

class RecommendUserTableCustomCell: UITableViewCell {
    static let identifier = "RecommendUserTableCustomCell"
    
    let userProfileImageView = UIImageView().then {
        $0.backgroundColor = UIColor.skeleton
        $0.layer.cornerRadius = 18
        $0.layer.borderWidth = 0.25
        $0.layer.borderColor = UIColor.ButtonBorderColor.cgColor
        $0.clipsToBounds = true
    }

    let userIDLabel = UILabel().then {
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 14, weight: .semibold)
        $0.backgroundColor = .clear
    }
    
    let penNameLabel = UILabel().then {
        $0.textColor = UIColor.SubLabelTextColor.withAlphaComponent(0.5)
        $0.font = UIFont.notoSansKR(size: 14, weight: .regular)
        $0.backgroundColor = .clear
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(userProfileImageView)
        contentView.addSubview(userIDLabel)
        contentView.addSubview(penNameLabel)
    }
    
    private func setupConstraints() {
        userProfileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.bottom.equalTo(-15)
        }
        
        userIDLabel.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageView).offset(-3)
            make.leading.equalTo(userProfileImageView.snp.trailing).offset(10)
        }
        
        penNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(userProfileImageView)
            make.leading.equalTo(userProfileImageView.snp.trailing).offset(10)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let color = UIColor.ButtonBorderColor
        let resolvedColor = color.resolvedColor(with: traitCollection)
        userProfileImageView.layer.borderColor = resolvedColor.cgColor
        userProfileImageView.layer.borderWidth = 0.25
    }
}
