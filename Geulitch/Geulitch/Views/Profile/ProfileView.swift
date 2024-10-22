//
//  ProfileView.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/15/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SkeletonView

final class ProfileView: UIView {
    let disposeBag = DisposeBag()
    
    let headerView = UIView().then {
        $0.backgroundColor = UIColor.primaryBackgroundColor
    }
    
    let userProfileImageButton = UIButton().then {
        $0.setImage(UIImage(named: "DefaultUserProfileImage"), for: .normal)
        $0.backgroundColor = UIColor.systemGray
        $0.layer.cornerRadius = 27
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.systemGray.withAlphaComponent(0.3).cgColor
    }
    
    let penNameLabel = UILabel().then {
        $0.text = "유저이름"
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 18, weight: .bold)
    }
    
    let userIDLabel = UILabel().then {
        $0.text = "userid"
        $0.textColor = UIColor.SubLabelTextColor
        $0.font = UIFont.notoSansKR(size: 14, weight: .regular)
    }
    
    let postsTableView = UITableView().then {
        $0.backgroundColor = UIColor.primaryBackgroundColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.tableFooterView = UIView()
    }
    
    let postBlurbTextView = UITextView().then {
        $0.text = "자기소개 테스트 자기소개 동적인 높이 되는지 테스트 중 자기소개 테스트 자기소개 동적인 높이 되는지 테스트 중"
        $0.textColor = UIColor.primaryTextColor
        $0.backgroundColor = UIColor.clear
        $0.font = UIFont.notoSansKR(size: 14, weight: .regular)
        $0.isScrollEnabled = false
        $0.isUserInteractionEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    let numberOfFollowerSatatusButton = UIButton().then {
        $0.setTitle("구독자 0명", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansKR(size: 14, weight: .regular)
        $0.setTitleColor(UIColor.SubLabelTextColor, for: .normal)
        $0.backgroundColor = UIColor.clear
    }
    
    let profileEditButton = UIButton().then {
        $0.setTitle("프로필 편집", for: .normal)
        $0.backgroundColor = UIColor.AccentButtonBackgroundColor
//        $0.layer.borderColor = UIColor.ButtonBorderColor.cgColor
        $0.titleLabel?.font = UIFont.notoSansKR(size: 15, weight: .semibold)
        $0.setTitleColor(UIColor.AccentButtonTextColor, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTopView()
        setupTopViewConstraints()
        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = UIColor.primaryBackgroundColor
    }
    
    private func setupTopView() {
        addSubview(userProfileImageButton)
        addSubview(penNameLabel)
        addSubview(userIDLabel)
        addSubview(postBlurbTextView)
        addSubview(numberOfFollowerSatatusButton)
        addSubview(profileEditButton)
    }
    
    private func setupTopViewConstraints() {
        userProfileImageButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 54, height: 54))
        }
        
        penNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userProfileImageButton).offset(-10)
            make.leading.equalTo(userProfileImageButton.snp.trailing).offset(10)
        }
        
        userIDLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userProfileImageButton).offset(10)
            make.leading.equalTo(userProfileImageButton.snp.trailing).offset(10)
        }
        
        postBlurbTextView.snp.makeConstraints { make in
//            make.top.equalTo(userProfileImageButton.snp.bottom).offset(15)
            make.top.equalTo(userProfileImageButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
        
        numberOfFollowerSatatusButton.snp.makeConstraints { make in
//            make.top.equalTo(postBlurbTextView.snp.bottom).offset(10)
            make.top.equalTo(postBlurbTextView.snp.bottom)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(16)
        }
        
        profileEditButton.snp.makeConstraints { make in
            make.top.equalTo(numberOfFollowerSatatusButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(35)
        }
    }
    
    private func bindUI() {
        // 예: 프로필 편집 버튼이 눌렸을 때
        profileEditButton.rx.tap
            .subscribe(onNext: { [weak self] in
                print("프로필 편집 버튼이 눌렸습니다.")
            })
            .disposed(by: disposeBag)
        
        // 예: 팔로워 버튼이 눌렸을 때
        numberOfFollowerSatatusButton.rx.tap
            .subscribe(onNext: { [weak self] in
                print("팔로워 버튼이 눌렸습니다.")
            })
            .disposed(by: disposeBag)
        
        // 프로필 이미지 버튼 이벤트 핸들링 예제
        userProfileImageButton.rx.tap
            .subscribe(onNext: { [weak self] in
                print("프로필 이미지 버튼이 눌렸습니다.")
            })
            .disposed(by: disposeBag)
    }
}

