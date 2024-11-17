//
//  SearchHistoryTableCustomCell.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 11/9/24.
//

import UIKit
import SnapKit
import Then
import AVKit

class SearchHistoryTableCustomCell: UITableViewCell {
    static let identifier = "SearchHistoryTableCustomCell"
    
    let userProfileImageButton = UIButton().then {
        $0.setImage(UIImage(named: "DefaultUserProfileImage"), for: .normal)
        $0.backgroundColor = UIColor.skeleton
        $0.layer.cornerRadius = 18
        $0.layer.borderWidth = 0.25
        $0.layer.borderColor = UIColor.ButtonBorderColor.cgColor
    }

    let userIDLabel = UILabel().then {
        $0.text = "geulitch"
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 14, weight: .semibold)
        $0.backgroundColor = .clear
    }
    
    let penNameLabel = UILabel().then {
        $0.text = "geulitch_official"
        $0.textColor = UIColor.SubLabelTextColor.withAlphaComponent(0.5)
        $0.font = UIFont.notoSansKR(size: 14, weight: .regular)
        $0.backgroundColor = .clear
    }
    
    let searchTextIcon = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)), for: .normal)
        $0.tintColor = UIColor.SubLabelTextColor
    }
    
    let searchTextLabel = UILabel().then {
        $0.text = "geulitch_official"
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 14, weight: .semibold)
        $0.backgroundColor = .clear
    }
    
    let deleteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)), for: .normal)
        $0.tintColor = UIColor.primaryTextColor
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(userProfileImageButton)
        contentView.addSubview(userIDLabel)
        contentView.addSubview(penNameLabel)
        contentView.addSubview(searchTextIcon)
        contentView.addSubview(searchTextLabel)
        contentView.addSubview(deleteButton)
    }
    
    func setupSearchUserConstraints() {
        userProfileImageButton.isHidden = false
        userIDLabel.isHidden = false
        penNameLabel.isHidden = false
        searchTextIcon.isHidden = true
        searchTextLabel.isHidden = true
        deleteButton.isHidden = false

        userProfileImageButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.bottom.equalTo(-15)
        }
        
        userIDLabel.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageButton).offset(-3)
            make.leading.equalTo(userProfileImageButton.snp.trailing).offset(10)
        }
        
        penNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(userProfileImageButton)
            make.leading.equalTo(userProfileImageButton.snp.trailing).offset(10)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(userProfileImageButton)
            make.trailing.equalTo(-15)
        }
    }
    
    func setupSearchTextConstraints() {
        searchTextIcon.isHidden = false
        searchTextLabel.isHidden = false
        userProfileImageButton.isHidden = true
        userIDLabel.isHidden = true
        penNameLabel.isHidden = true
        deleteButton.isHidden = false

        searchTextIcon.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 36, height: 36))
            make.bottom.equalTo(-15)
        }
        
        searchTextLabel.snp.makeConstraints { make in
            make.centerY.equalTo(searchTextIcon).offset(-3)
            make.leading.equalTo(searchTextIcon.snp.trailing).offset(10)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchTextIcon)
            make.trailing.equalTo(-15)
        }
    }
}
