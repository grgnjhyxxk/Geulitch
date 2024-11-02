//
//  RecommendedTableCustomCell.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/12/24.
//

import UIKit
import SnapKit
import Then

class FeedTableCustomCell: UITableViewCell {
    static let identifier = "FeedTableCustomCell"
    
    private var postTitleHeightConstraint: Constraint?
    private var postBlurbHeightConstraint: Constraint?
    
    let userProfileImageButton = UIButton().then {
        $0.setImage(UIImage(named: "DefaultUserProfileImage"), for: .normal)
        $0.backgroundColor = UIColor.skeleton
        $0.layer.cornerRadius = 18
    }
    
    let penNameButton = UIButton().then {
        $0.setTitle("김상민그는감히전설이라고할수있다", for: .normal)
        $0.setTitleColor(UIColor.primaryTextColor, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansKR(size: 14, weight: .medium)
    }
    
    let userIDButton = UIButton().then {
        $0.setTitle("crea_tio_jewelry", for: .normal)
        $0.setTitleColor(UIColor.primaryTextColor, for: .normal)
        $0.titleLabel?.font = UIFont.notoSans(size: 14, weight: .semibold)
        $0.backgroundColor = .clear
    }
    
    let postTitleTextLabel = UILabel().then {
        $0.text = "게시글 제목"
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 16, weight: .medium)
        $0.isUserInteractionEnabled = false
    }
    
    let postBlurbTextLabel = UILabel().then {
        $0.text = "본문 내용 동적인 높이 테스트, 본문 내용 동적인 높이 테스트, 본문 내용 동적인 높이 테스트, 본문 내용 동적인 높이 테스트, 본문 내용 동적인 높이 테스트, 본문 내용 동적인 높이 테스트"
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
        $0.text = "1일전"
        $0.textColor = UIColor.SubLabelTextColor.withAlphaComponent(0.3)
        $0.font = UIFont.notoSansKR(size: 14, weight: .regular)
    }
    
    let ellipsisButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis")?.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.tintColor = UIColor.SubLabelTextColor
    }
    
    let postLikeSatatusButton = UIButton().then {
        $0.setTitle("좋아요·0", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansKR(size: 14, weight: .regular)
        $0.setTitleColor(UIColor.SubButtonBackgoundColor, for: .normal)
        $0.backgroundColor = UIColor.clear
    }
    
    let postCommentSatatusButton = UIButton().then {
        $0.setTitle("댓글·0", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansKR(size: 14, weight: .regular)
        $0.setTitleColor(UIColor.SubButtonBackgoundColor, for: .normal)
        $0.backgroundColor = UIColor.clear
    }
    
    let postPreViewImageView = UIImageView().then {
        $0.backgroundColor = UIColor.skeleton
        $0.layer.cornerRadius = 10
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
        contentView.addSubview(penNameButton)
        contentView.addSubview(userIDButton)
        contentView.addSubview(dateLabel)
        contentView.addSubview(ellipsisButton)
        contentView.addSubview(postTitleTextLabel)
        contentView.addSubview(postBlurbTextLabel)
        contentView.addSubview(postPreViewImageView)
        contentView.addSubview(postLikeSatatusButton)
        contentView.addSubview(postCommentSatatusButton)
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
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func addTargets() {
        ellipsisButton.addTarget(self, action: #selector(ellipsisButtonTapped), for: .touchUpInside)
    }

    @objc func ellipsisButtonTapped(sender: UIButton) {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackgenerator.impactOccurred()
    }
}

import SkeletonView

class SkeletonTableViewCell: UITableViewCell {
    static let identifier = "SkeletonTableViewCell"
    
    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SkeletonColor")
        view.layer.cornerRadius = 18 // 반지름을 반으로 해서 원 모양으로
        view.isSkeletonable = true
        view.skeletonCornerRadius = 18
        return view
    }()
    
    let lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SkeletonColor")
        view.layer.cornerRadius = 7
        view.isSkeletonable = true
        view.skeletonCornerRadius = 7
        return view
    }()
    
    let lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SkeletonColor")
        view.layer.cornerRadius = 7
        view.isSkeletonable = true
        view.skeletonCornerRadius = 7
        return view
    }()
    
    let lineView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SkeletonColor")
        view.layer.cornerRadius = 7
        view.isSkeletonable = true
        view.skeletonCornerRadius = 7
        return view
    }()
    
    let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SkeletonColor")
        view.layer.cornerRadius = 7 // 반지름을 반으로 해서 원 모양으로
        view.isSkeletonable = true
        view.skeletonCornerRadius = 7
        return view
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        contentView.addSubview(circleView)
        contentView.addSubview(lineView1)
        contentView.addSubview(lineView2)
        contentView.addSubview(lineView3)
        contentView.addSubview(dotView)
        
        circleView.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.leading.equalTo(15)
            make.size.equalTo(CGSize(width: 36, height: 36))
        }
        
        lineView1.snp.makeConstraints { make in
            make.top.equalTo(circleView)
            make.leading.equalTo(circleView.snp.trailing).offset(10)
            make.trailing.equalTo(-200)
            make.height.equalTo(13)
        }
        
        lineView2.snp.makeConstraints { make in
            make.bottom.equalTo(circleView)
            make.leading.equalTo(circleView.snp.trailing).offset(10)
            make.trailing.equalTo(-40)
            make.height.equalTo(13)
        }
        
        lineView3.snp.makeConstraints { make in
            make.top.equalTo(lineView2.snp.bottom).offset(10)
            make.leading.equalTo(circleView.snp.trailing).offset(10)
            make.trailing.equalTo(-160)
            make.height.equalTo(13)
        }
        
        dotView.snp.makeConstraints { make in
            make.top.equalTo(lineView3)
            make.leading.equalTo(lineView3.snp.trailing).offset(10)
            make.width.equalTo(39)
            make.height.equalTo(13)
        }
        
        self.isSkeletonable = true
        contentView.isSkeletonable = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
