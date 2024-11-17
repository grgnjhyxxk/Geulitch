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
import SDWebImage

final class ProfileView: UIView {
    var disposeBag = DisposeBag()
    
    let headerView = UIView().then {
        $0.backgroundColor = UIColor.primaryBackgroundColor
    }
    
    let userIDLabel = UILabel().then {
        $0.font = UIFont.notoSansKR(size: 14, weight: .regular)
        $0.textColor = UIColor.SubLabelTextColor.withAlphaComponent(0.5)
    }
    
    let accountSettingBarButton = UIButton().then {
        $0.setImage(UIImage(systemName: "line.3.horizontal")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)), for: .normal)
        $0.tintColor = UIColor.AccentButtonBackgroundColor
        $0.backgroundColor = UIColor.skeleton
        $0.layer.cornerRadius = 17
    }
    
    let searchingPostButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)), for: .normal)
        $0.tintColor = UIColor.AccentButtonBackgroundColor
        $0.backgroundColor = UIColor.skeleton
        $0.layer.cornerRadius = 17
    }
    
    let moreBarButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)), for: .normal)
        $0.tintColor = UIColor.AccentButtonBackgroundColor
        $0.backgroundColor = UIColor.skeleton
        $0.layer.cornerRadius = 17
    }
    
    let privacySettingButton = UIButton().then {
        $0.setImage(UIImage(systemName: "lock")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)), for: .normal)
        $0.tintColor = UIColor.SubButtonBackgoundColor
        $0.backgroundColor = UIColor.skeleton
        $0.layer.cornerRadius = 17
    }
    
    let userProfileImageButton = UIButton().then {
        $0.backgroundColor = UIColor.skeleton
        $0.layer.cornerRadius = 35
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = 0.25
        $0.layer.borderColor = UIColor.ButtonBorderColor.cgColor
    }
    
    let penNameLabel = UILabel().then {
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 21, weight: .bold)
        $0.numberOfLines = 2
    }
    
    let postsTableView = UITableView().then {
        $0.backgroundColor = UIColor.primaryBackgroundColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.tableFooterView = UIView()
    }
    
    let introductionTextView = UITextView().then {
        $0.textColor = UIColor.primaryTextColor
        $0.backgroundColor = UIColor.clear
        $0.font = UIFont.notoSansKR(size: 14, weight: .regular)
        $0.textAlignment = .justified
        $0.isScrollEnabled = false
        $0.isUserInteractionEnabled = false
        $0.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
    }
    
    let numberOfFollowerSatatusButton = UIButton().then {
        $0.setTitle("구독자 0명", for: .normal)
        $0.titleLabel?.font = UIFont.notoSansKR(size: 14, weight: .regular)
        $0.setTitleColor(UIColor.SubLabelTextColor.withAlphaComponent(0.5), for: .normal)
        $0.backgroundColor = UIColor.clear
    }
    
    let profileEditButton = UIButton().then {
        $0.setTitle("프로필 편집", for: .normal)
        $0.backgroundColor = UIColor.primaryBackgroundColor
        $0.titleLabel?.font = UIFont.notoSansKR(size: 15, weight: .semibold)
        $0.setTitleColor(UIColor.primaryTextColor, for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.ButtonBorderColor.cgColor
        $0.isHidden = true
    }
    
    let subscribeButton = UIButton().then {
        $0.setTitle("구독", for: .normal)
        $0.backgroundColor = UIColor.AccentButtonBackgroundColor
        $0.titleLabel?.font = UIFont.notoSansKR(size: 15, weight: .semibold)
        $0.setTitleColor(UIColor.AccentButtonTextColor, for: .normal)
        $0.layer.cornerRadius = 10
        $0.isHidden = true
    }
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular)).then {
        $0.alpha = 0
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    let blurViewCancelButton = UIButton().then {
        $0.alpha = 0
        $0.setImage(UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 17, weight: .bold)), for: .normal)
        $0.tintColor = UIColor.primaryTextColor
        $0.backgroundColor = UIColor.skeleton
        $0.layer.cornerRadius = 17
    }
    
    let blurViewCancelFullButton = UIButton().then {
        $0.alpha = 0
        $0.backgroundColor = UIColor.clear
    }
    
    let userProfileImageView = UIImageView().then {
        $0.alpha = 0
        $0.backgroundColor = UIColor.skeleton
        $0.layer.cornerRadius = 125
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = 0.25
        $0.layer.borderColor = UIColor.ButtonBorderColor.cgColor
        $0.isUserInteractionEnabled = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupTopView()
        setupTopViewConstraints()
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
        addSubview(introductionTextView)
        addSubview(numberOfFollowerSatatusButton)
        addSubview(profileEditButton)
        addSubview(subscribeButton)
    }
    
    private func setupTopViewConstraints() {
        userProfileImageButton.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.trailing.equalToSuperview().offset(-15)
            make.size.equalTo(CGSize(width: 70, height: 70))
        }
        
        penNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userProfileImageButton)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
        }
        
        userIDLabel.snp.makeConstraints { make in
            make.bottom.equalTo(userProfileImageButton)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
        }
        
        introductionTextView.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
        
        numberOfFollowerSatatusButton.snp.makeConstraints { make in
            make.top.equalTo(introductionTextView.snp.bottom)
            make.leading.equalToSuperview().offset(15)
            make.height.equalTo(16)
        }
        
        profileEditButton.snp.makeConstraints { make in
            make.top.equalTo(numberOfFollowerSatatusButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(35)
        }
        
        subscribeButton.snp.makeConstraints { make in
            make.top.equalTo(numberOfFollowerSatatusButton.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(35)
        }
    }
    
    func bindUserData(userObservable: Observable<UserData>) {
        disposeBag = DisposeBag()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .justified

        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .foregroundColor: UIColor.primaryTextColor,
            .font: UIFont.notoSansKR(size: 14, weight: .regular)
        ]
        
        // penNameLabel 바인딩
        userObservable
            .compactMap { $0 }
            .flatMap { $0.penName.asObservable() }
            .do(onNext: { text in
                print("Pen Name: \(text ?? "No Pen Name")")  // 디버깅 로그
            })
            .bind(to: penNameLabel.rx.text)
            .disposed(by: disposeBag)

        // introductionTextView 바인딩
        userObservable
            .compactMap { $0 }
            .flatMap { $0.introduction.asObservable() }
            .do(onNext: { text in
                print("Introduction: \(text)")  // 디버깅 로그
            })
            .subscribe(onNext: { [weak self] text in
                let attrString = NSMutableAttributedString(string: text, attributes: defaultAttributes)
                self?.introductionTextView.attributedText = attrString
            })
            .disposed(by: disposeBag)

        // userIDButton 바인딩
        userObservable
            .compactMap { $0 }
            .flatMap { $0.userID.asObservable() }
            .map { "@\($0)" }
            .do(onNext: { text in
                print("User ID: \(text)")  // 디버깅 로그
            })
            .bind(to: userIDLabel.rx.text)
            .disposed(by: disposeBag)

        // 프로필 이미지 바인딩
        userObservable
            .compactMap { $0 }
            .flatMap { $0.userProfileImage.asObservable() }
            .do(onNext: { imageURL in
                print("User Profile Image URL: \(imageURL ?? "No URL")")  // 디버깅 로그
            })
            .subscribe(onNext: { [weak self] imageURL in
                if let urlString = imageURL, let url = URL(string: urlString) {
                    self?.userProfileImageButton.sd_setImage(with: url, for: .normal, placeholderImage: UIImage())
                } else {
                    self?.userProfileImageButton.setImage(UIImage(named: "DefaultUserProfileImage"), for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        userObservable
            .compactMap { $0 }
            .flatMap { $0.userProfileImage.asObservable() }
            .do(onNext: { imageURL in
                print("User Profile Image URL: \(imageURL ?? "No URL")")  // 디버깅 로그
            })
            .subscribe(onNext: { [weak self] imageURL in
                if let urlString = imageURL, let url = URL(string: urlString) {
                    self?.userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage())
                } else {
                    self?.userProfileImageView.image = UIImage(named: "DefaultUserProfileImage")
                }
            })
            .disposed(by: disposeBag)
        
        // followerButton 바인딩
        userObservable
            .compactMap { $0 }
            .flatMap { $0.follower.asObservable() }
            .do(onNext: { followers in
                print("Follower Count: \(followers.count)")  // 디버깅 로그
            })
            .map { "구독자 \($0.count)명" }
            .bind(to: numberOfFollowerSatatusButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        // privacySettingButton 바인딩
        userObservable
            .compactMap { $0 }
            .flatMap { $0.privacySetting.asObservable() }
            .do(onNext: { privacySetting in
                print("PrivacySetting:  \(privacySetting)")
            })
            .map { $0 ? UIColor.AccentButtonBackgroundColor : UIColor.SubButtonBackgoundColor }
            .subscribe(onNext: { [weak self] color in
                self?.privacySettingButton.tintColor = color
            })
            .disposed(by: disposeBag)
    }    
}

