//
//  RecommendedTableCustomCell.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/12/24.
//

import UIKit
import SnapKit
import Then

class RecommendedTableCustomCell: UITableViewCell {
    static let identifier = "RecommendedTableCustomCell"
    
    private var postTitleHeightConstraint: Constraint?
    private var postBlurbHeightConstraint: Constraint?
    
    let penNameButton = UIButton().then {
        $0.setTitle("글리치", for: .normal)
        $0.setTitleColor(UIColor.SubLabelTextColor.withAlphaComponent(0.8), for: .normal)
        $0.titleLabel?.font = UIFont.notoSansKR(size: 14, weight: .light)
    }
    
    let userIDButton = UIButton().then {
        $0.setTitle("@geulitch", for: .normal)
        $0.setTitleColor(UIColor.SubLabelTextColor.withAlphaComponent(0.8), for: .normal)
        $0.titleLabel?.font = UIFont.notoSansKR(size: 14, weight: .light)
    }
    
    let postTitleTextLabel = UILabel().then {
        $0.text = "게시글 제목"
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 16, weight: .medium)
        $0.isUserInteractionEnabled = false
    }
    
    let postBlurbTextLabel = UILabel().then {
        $0.text = "본문 내용 동적인 높이 테스트, 본문 내용 동적인 높이 테스트, 본문 내용 동적인 높이 테스트, 본문 내용 동적인 높이 테스트, 본문 내용 동적인 높이 테스트, 본문 내용 동적인 높이 테스트"
        $0.textColor = UIColor.SubLabelTextColor
        $0.font = UIFont.notoSansKR(size: 14, weight: .light)
        $0.textAlignment = .justified
        $0.isUserInteractionEnabled = false
        $0.numberOfLines = 0
    }
    
    let dateLabel = UILabel().then {
        $0.text = "1일전"
        $0.textColor = UIColor.SubButtonBackgoundColor
        $0.font = UIFont.notoSansKR(size: 14, weight: .light)
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
        $0.backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
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
        penNameButton.snp.makeConstraints { make in
            make.top.equalTo(25)
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(penNameButton.titleLabel!.snp.width)
            make.height.equalTo(20)
        }
        
        userIDButton.snp.makeConstraints { make in
            make.top.equalTo(penNameButton).offset(-1)
            make.leading.equalTo(penNameButton.snp.trailing).offset(5)
            make.width.equalTo(userIDButton.titleLabel!.snp.width)
            make.height.equalTo(20)
        }
        
        ellipsisButton.snp.makeConstraints { make in
            make.top.equalTo(penNameButton)
            make.trailing.equalTo(-15)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
//        dateLabel.snp.makeConstraints { make in
//            make.top.equalTo(penNameButton)
//            make.trailing.equalTo(ellipsisButton.snp.leading).offset(-8)
//        }
  
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(penNameButton)
            make.trailing.equalTo(-15)
        }
        
        postTitleTextLabel.snp.makeConstraints { make in
            make.top.equalTo(penNameButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(postPreViewImageView.snp.leading).offset(-15)
            make.height.equalTo(20)
        }
        
        postBlurbTextLabel.snp.makeConstraints { make in
            make.top.equalTo(postTitleTextLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalTo(postPreViewImageView.snp.leading).offset(-15)
            make.bottom.equalTo(postPreViewImageView)
        }
        
        postPreViewImageView.snp.makeConstraints { make in
            make.top.equalTo(postTitleTextLabel)
            make.trailing.equalTo(-15)
            make.width.height.equalTo(93)
        }
        
        postLikeSatatusButton.snp.makeConstraints { make in
            make.top.equalTo(postPreViewImageView.snp.bottom).offset(15)
            make.leading.equalTo(15)
            make.width.equalTo(postLikeSatatusButton.titleLabel!.snp.width)
            make.height.equalTo(15)
        }

        postCommentSatatusButton.snp.makeConstraints { make in
            make.top.equalTo(postPreViewImageView.snp.bottom).offset(15)
            make.leading.equalTo(postLikeSatatusButton.snp.trailing).offset(15)
            make.width.equalTo(postCommentSatatusButton.titleLabel!.snp.width)
            make.height.equalTo(15)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        penNameButton.isHidden = true
//        userIDButton.isHidden = true
//        dateLabel.isHidden = true
        ellipsisButton.isHidden = true
        postLikeSatatusButton.isHidden = true
        postCommentSatatusButton.isHidden = true

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
    
    let squareView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SkeletonColor")
        view.layer.cornerRadius = 10 // 반지름을 반으로 해서 원 모양으로
        view.isSkeletonable = true
        view.skeletonCornerRadius = 10
        return view
    }()
    
    let lineView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SkeletonColor")
        view.layer.cornerRadius = 10
        view.isSkeletonable = true
        view.skeletonCornerRadius = 10
        return view
    }()
    
    let lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SkeletonColor")
        view.layer.cornerRadius = 10
        view.isSkeletonable = true
        view.skeletonCornerRadius = 10
        return view
    }()
    
    let lineView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SkeletonColor")
        view.layer.cornerRadius = 10
        view.isSkeletonable = true
        view.skeletonCornerRadius = 10
        return view
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear

        contentView.addSubview(squareView)
        contentView.addSubview(lineView1)
        contentView.addSubview(lineView2)
        contentView.addSubview(lineView3)
        
        squareView.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.trailing.equalTo(-15)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        lineView1.snp.makeConstraints { make in
            make.top.equalTo(squareView)
            make.leading.equalTo(15)
            make.trailing.equalTo(squareView.snp.leading).offset(-15)
            make.height.equalTo(19)
        }
        
        lineView2.snp.makeConstraints { make in
            make.centerY.equalTo(squareView)
            make.leading.equalTo(15)
            make.trailing.equalTo(squareView.snp.leading).offset(-75)
            make.height.equalTo(19)
        }
        
        lineView3.snp.makeConstraints { make in
            make.bottom.equalTo(squareView)
            make.leading.equalTo(15)
            make.trailing.equalTo(squareView.snp.leading).offset(-135)
            make.height.equalTo(19)
        }
        
        self.isSkeletonable = true
        contentView.isSkeletonable = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
