//
//  AuthenticationView.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/7/24.
//

import UIKit
import SnapKit
import Then

class AuthenticationView: UIView {
    let mainTitleLabel = UILabel().then {
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 28, weight: .medium)
        $0.numberOfLines = 0
        $0.text = "세상에 작은 결함들이 모여 특별한 이야기가 됩니다. 나만의 글로 그 결함을 완성해 보세요."
        $0.textAlignment = .justified
    }
    
    let subTitleLabel = UILabel().then {
        $0.textColor = UIColor.SubLabelTextColor
        $0.font = UIFont.notoSansKR(size: 16, weight: .regular)
        $0.text = "불완전한 세상을 글로 완전하게"
    }

    let loginButton = UIButton().then {
        $0.backgroundColor = UIColor.AccentButtonBackgroundColor

        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true

        let fullText = "기존 계정으로 로그인하기"
        let boldText = "기존 계정"
        
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [.font: UIFont.notoSansKR(size: 16, weight: .regular)]
        )
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.notoSansKR(size: 16, weight: .bold)
        ]
        
        attributedString.addAttributes(boldFontAttribute, range: (fullText as NSString).range(of: boldText))
        
        $0.setAttributedTitle(attributedString, for: .normal)

        $0.setTitleColor(UIColor.AccentButtonTextColor, for: .normal)
    }

    
    let registerButton = UIButton().then {
        $0.backgroundColor = UIColor.SubButtonBackgoundColor
        
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true

        let fullText = "새로운 계정으로 시작하기"
        let boldText = "새로운 계정"
        
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [.font: UIFont.notoSansKR(size: 16, weight: .regular)]
        )
        
        let boldFontAttribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.notoSansKR(size: 16, weight: .bold)
        ]
        
        attributedString.addAttributes(boldFontAttribute, range: (fullText as NSString).range(of: boldText))
        
        $0.setAttributedTitle(attributedString, for: .normal)

        $0.setTitleColor(UIColor.SubButtonTextColor, for: .normal)
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
        addSubview(mainTitleLabel)
        addSubview(subTitleLabel)
        addSubview(registerButton)
        addSubview(loginButton)
    }
    
    private func setupConstraints() {
        mainTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(220)
            make.leading.equalTo(34)
            make.trailing.equalTo(-34)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(20)
            make.leading.equalTo(34)
            make.trailing.equalTo(-34)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(150)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 330, height: 40))
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 330, height: 40))
        }
    }
}
