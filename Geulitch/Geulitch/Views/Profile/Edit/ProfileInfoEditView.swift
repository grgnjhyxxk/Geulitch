//
//  ProfileInfoEditView.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/23/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import SDWebImage

class ProfileInfoEditView: UIView {
    let disposeBag = DisposeBag()
    
    let tableView = UITableView().then {
        $0.backgroundColor = UIColor.primaryBackgroundColor
        $0.register(ProfileInfoEditTableCustomCell.self, forCellReuseIdentifier: ProfileInfoEditTableCustomCell.identifier)
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen().bounds.width, height: 170)).then {
        $0.backgroundColor = UIColor.primaryBackgroundColor
    }
    
    let userProfileImageView = UIImageView().then {
        $0.backgroundColor = UIColor.skeleton
        $0.layer.cornerRadius = 40
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = 0.25
        $0.layer.borderColor = UIColor.ButtonBorderColor.cgColor
    }
    
    let userProfileImageEditButton = UIButton().then {
        $0.setTitle("이미지 변경", for: .normal)
        $0.backgroundColor = UIColor.primaryBackgroundColor
        $0.titleLabel?.font = UIFont.notoSansKR(size: 15, weight: .semibold)
        $0.setTitleColor(UIColor.primaryTextColor, for: .normal)
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.ButtonBorderColor.cgColor
    }
    
    let userProfileImageDeleteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "trash")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)), for: .normal)
        $0.backgroundColor = UIColor.primaryBackgroundColor
        $0.tintColor = UIColor.primaryTextColor
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.ButtonBorderColor.cgColor
    }
    
    let separatorView = UIView().then {
        $0.backgroundColor = UIColor.separator
    }
        
    let activityIndicator = UIActivityIndicatorView().then {
        $0.backgroundColor = UIColor.ActivityBackgroundColor
        $0.color = UIColor.ActivityColor
        $0.style = .large
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupViewConstraints()
        bindUserData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(tableView)
        addSubview(activityIndicator)
        
        tableView.tableHeaderView = headerView
        
        headerView.addSubview(userProfileImageView)
        headerView.addSubview(userProfileImageEditButton)
        headerView.addSubview(separatorView)
        headerView.addSubview(userProfileImageDeleteButton)
            
        activityIndicator.isHidden = true
    }
    
    private func setupViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        userProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        userProfileImageEditButton.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageView.snp.bottom).offset(22)
            make.centerX.equalToSuperview().offset(-15)
            make.width.equalTo(userProfileImageEditButton.titleLabel!.snp.width).offset(52)
            make.height.equalTo(30)
        }
        
        userProfileImageDeleteButton.snp.makeConstraints { make in
            make.top.equalTo(userProfileImageView.snp.bottom).offset(22)
            make.leading.equalTo(userProfileImageEditButton.snp.trailing).offset(5)
            make.width.height.equalTo(30)
        }
        
        separatorView.snp.makeConstraints { make in
            make.bottom.width.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindUserData() {
        // LoggedInUserManager.shared.loggedInUser은 사용자 데이터가 저장된 위치라고 가정
        LoggedInUserManager.shared.loggedInUser
            .compactMap { $0 }  // nil이 아닐 때만 처리
            .flatMap { $0.userProfileImage.asObservable() }  // 프로필 이미지 URL을 옵저빙
            .subscribe(onNext: { [weak self] imageURL in
                if let urlString = imageURL, let url = URL(string: urlString) {
                    // 비동기적으로 이미지 로드, 기본 이미지도 설정
                    self?.userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage())
                } else {
                    // 이미지 URL이 없을 경우 기본 이미지 설정
                    self?.userProfileImageView.image = UIImage(named: "DefaultUserProfileImage")
                }
            })
            .disposed(by: disposeBag)  // 메모리 관리
    }
}
