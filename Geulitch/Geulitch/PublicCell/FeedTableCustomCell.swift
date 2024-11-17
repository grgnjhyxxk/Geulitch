//
//  RecommendedTableCustomCell.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/12/24.
//

import UIKit
import SnapKit
import Then
import AVKit

class FeedTableCustomCell: UITableViewCell {
    static let identifier = "FeedTableCustomCell"
    
    private var postTitleHeightConstraint: Constraint?
    private var postBlurbHeightConstraint: Constraint?

    let userProfileImageButton = UIButton().then {
        $0.backgroundColor = UIColor.skeleton
        $0.layer.cornerRadius = 18
        $0.layer.borderWidth = 0.25
        $0.layer.borderColor = UIColor.ButtonBorderColor.cgColor
    }

    let userIDButton = UIButton().then {
        $0.setTitleColor(UIColor.primaryTextColor, for: .normal)
        $0.titleLabel?.font = UIFont.notoSans(size: 14, weight: .semibold)
        $0.backgroundColor = .clear
    }
    
    let postBlurbTextLabel = UILabel().then {
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 14, weight: .regular)
        $0.isUserInteractionEnabled = false
        $0.numberOfLines = 0
        
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .justified
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        
        $0.attributedText = attrString
    }
    
    let dateLabel = UILabel().then {
        $0.textColor = UIColor.SubLabelTextColor.withAlphaComponent(0.5)
        $0.font = UIFont.notoSansKR(size: 14, weight: .regular)
    }
    
    let ellipsisButton = UIButton().then {
        $0.tintColor = UIColor.SubLabelTextColor
    }
    
    let mediaContentView = UIView().then {
        $0.backgroundColor = UIColor.clear
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    let mediaContentButton_1 = UIButton().then {
        $0.backgroundColor = UIColor.skeleton
        $0.clipsToBounds = true
        $0.imageView?.contentMode = .scaleAspectFill
    }
    
    let mediaContentButton_2 = UIButton().then {
        $0.backgroundColor = UIColor.skeleton
        $0.clipsToBounds = true
        $0.imageView?.contentMode = .scaleAspectFill
    }

    let mediaContentButton_3 = UIButton().then {
        $0.backgroundColor = UIColor.skeleton
        $0.clipsToBounds = true
        $0.imageView?.contentMode = .scaleAspectFill
    }

    let mediaContentButton_4 = UIButton().then {
        $0.backgroundColor = UIColor.skeleton
        $0.clipsToBounds = true
        $0.imageView?.contentMode = .scaleAspectFill
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupView()
        setupConstraints()
        addTargets()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.addSubview(userProfileImageButton)
        contentView.addSubview(userIDButton)
        contentView.addSubview(dateLabel)
        contentView.addSubview(ellipsisButton)
        contentView.addSubview(postBlurbTextLabel)
        contentView.addSubview(mediaContentView)
        mediaContentView.addSubview(mediaContentButton_1)
        mediaContentView.addSubview(mediaContentButton_2)
        mediaContentView.addSubview(mediaContentButton_3)
        mediaContentView.addSubview(mediaContentButton_4)
    }
    
    private func setupConstraints() {
        userProfileImageButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }

        userIDButton.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageButton).offset(-3)
            make.leading.equalTo(userProfileImageButton.snp.trailing).offset(10)
            make.height.equalTo(17)
            make.width.equalTo(userIDButton.intrinsicContentSize.width) // 텍스트 너비에 맞춤
        }

        ellipsisButton.snp.makeConstraints { make in
            make.centerY.equalTo(dateLabel)
            make.trailing.equalTo(-15)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageButton).offset(-6)
            make.trailing.equalTo(ellipsisButton.snp.leading).offset(-9)
        }
        
        postBlurbTextLabel.snp.makeConstraints { make in
            make.top.equalTo(userIDButton.snp.bottom).offset(3.5)
            make.leading.equalTo(userProfileImageButton.snp.trailing).offset(10)
            make.trailing.equalTo(-15)
            make.bottom.equalTo(mediaContentView.snp.top).offset(-10)
        }
        
        mediaContentView.snp.makeConstraints { make in
            make.height.equalTo(160)
            make.leading.equalTo(userProfileImageButton.snp.trailing).offset(10)
            make.trailing.equalTo(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
        
        mediaContentButton_1.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-2)
        }

        mediaContentButton_2.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-2)
        }
        
        mediaContentButton_3.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-2)
        }
        
        mediaContentButton_4.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5).offset(-2)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-2)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let color = UIColor.ButtonBorderColor
        let resolvedColor = color.resolvedColor(with: traitCollection)
        userProfileImageButton.layer.borderColor = resolvedColor.cgColor
        userProfileImageButton.layer.borderWidth = 0.25
        
        mediaContentView.layer.borderColor = resolvedColor.cgColor
        mediaContentView.layer.borderWidth = 0.25
    }
    
    private func addTargets() {
        ellipsisButton.addTarget(self, action: #selector(ellipsisButtonTapped), for: .touchUpInside)
    }

    @objc func ellipsisButtonTapped(sender: UIButton) {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackgenerator.impactOccurred()
    }
}
