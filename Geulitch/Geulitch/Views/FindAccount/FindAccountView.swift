//
//  FindAccountView.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/5/24.
//

import UIKit
import Then
import SnapKit

class FindAccountView: UIView {
    let foundIDTitleLabel = UILabel().then {
        $0.textColor = UIColor.primaryLabelText
        $0.numberOfLines = 0
    }
    
    let resetPasswordButton = UIButton().then {
        $0.backgroundColor = UIColor.clear
        $0.titleLabel?.font = UIFont.notoSansKR(size: 13, weight: .medium)
        $0.setTitleColor(UIColor.UnderlineButtonTextColor, for: .normal)
        $0.sizeToFit()
        
        let title = "비밀번호 재설정"
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )

        $0.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    let foundUserProfileImageView = UIImageView().then {
        $0.backgroundColor = UIColor.systemGray
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    let goToLoginButton = UIButton().then {
        $0.setTitle("로그인하러 가기", for: .normal)
        $0.backgroundColor = UIColor.AccentButtonBackgroundColor
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.titleLabel?.font = UIFont.notoSansKR(size: 16, weight: .bold)
        $0.setTitleColor(UIColor.AccentButtonTextColor, for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(foundIDTitleLabel)
        addSubview(resetPasswordButton)
        addSubview(foundUserProfileImageView)
        addSubview(goToLoginButton)
    }
    
    private func setupConstraints() {
        foundUserProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(140)
            make.trailing.equalTo(-15)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        foundIDTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(foundUserProfileImageView)
            make.leading.equalTo(15)
            make.trailing.equalTo(foundUserProfileImageView.snp.leading).offset(-15)
        }
        
        resetPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(foundIDTitleLabel.snp.bottom).offset(15)
            make.leading.equalTo(foundIDTitleLabel)
        }
        
        goToLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(-40)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 360, height: 40))
        }
    }
    
    func configure(userID: String, userProfileImage: UIImage) {
        let fullText = "기존 가입하신\n아이디는\n\(userID) 입니다."
        let boldText = "\(userID)"
        
        // 기본 속성으로 NSAttributedString 생성
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [.font: UIFont.notoSansKR(size: 26, weight: .regular)]
        )
        
        // 볼드 처리할 텍스트 속성
        let boldFontAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.notoSansKR(size: 26, weight: .bold)
        ]
        
        // 지정된 범위에 볼드 속성 추가
        attributedString.addAttributes(boldFontAttribute, range: (fullText as NSString).range(of: boldText))
        
        // attributedText에 NSAttributedString 적용
        foundIDTitleLabel.attributedText = attributedString
        
        
        foundUserProfileImageView.image = userProfileImage
    }
}
