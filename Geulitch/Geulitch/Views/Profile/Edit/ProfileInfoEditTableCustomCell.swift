//
//  ProfileInfoEditTableCustomCell.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/25/24.
//

import UIKit
import SnapKit
import Then
import RxSwift

class ProfileInfoEditTableCustomCell: UITableViewCell {
    static let identifier = "ProfileInfoEditTableCustomCell"
    let disposeBag = DisposeBag()
    
    let titleLabel = UILabel().then {
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 16, weight: .regular)
    }

    let titleInfoLabel = UILabel().then {
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 16, weight: .regular)
        $0.textAlignment = .justified
        $0.numberOfLines = 0
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleInfoLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleInfoLabel)
            make.leading.equalTo(10)
        }
        
        titleInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.equalTo(110)
            make.trailing.equalTo(-15)
            make.bottom.equalTo(-10)
        }
    }
    
    func bindUserIDData() {
        titleLabel.text = "아이디"

        LoggedInUserManager.shared.loggedInUser
            .compactMap { $0 } // 옵셔널을 제거하여 값이 있을 때만 바인딩
            .flatMap { $0.userID.asObservable() }
            .bind(to: titleInfoLabel.rx.text)
            .disposed(by: disposeBag)
        
        titleInfoLabel.textColor = UIColor.primaryTextColor
    }
    
    func bindPenNameData() {
        titleLabel.text = "필명"

        LoggedInUserManager.shared.loggedInUser
            .compactMap { $0 } // 옵셔널을 제거하여 값이 있을 때만 바인딩
            .flatMap { $0.penName.asObservable() }
            .bind(to: titleInfoLabel.rx.text)
        
            .disposed(by: disposeBag)
            
        titleInfoLabel.textColor = UIColor.primaryTextColor
    }
    
    func bindIntroductionData() {
        titleLabel.text = "자기소개"
        
        LoggedInUserManager.shared.loggedInUser
            .compactMap { $0 } // 옵셔널을 제거하여 값이 있을 때만 바인딩
            .flatMap { $0.introduction.asObservable() }
            .map { introduction -> (String, UIColor) in
                if introduction.isEmpty {
                    return ("자기소개", .systemGray) // 텍스트가 비어있으면 "자기소개"와 글씨 색을 systemGray로 설정
                } else {
                    return (introduction, .primaryTextColor) // 텍스트가 있으면 그대로 설정하고 글씨 색을 black으로 설정
                }
            }
            .subscribe(onNext: { [weak self] (text, color) in
                self?.titleInfoLabel.text = text
                self?.titleInfoLabel.textColor = color
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                paragraphStyle.alignment = .justified
                
                // 텍스트가 이미 설정되어 있다고 가정
                let attrString = NSMutableAttributedString(string: text)
                attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
                
                self?.titleInfoLabel.attributedText = attrString
            })
            .disposed(by: disposeBag)
    }
}
