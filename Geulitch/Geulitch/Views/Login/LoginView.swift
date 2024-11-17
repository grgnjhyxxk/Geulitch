//
//  LoginView.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/2/24.
//

import UIKit
import Then
import SnapKit

class LoginView: UIView {
    let userIdInputTextFieldTitleIcon = UIImageView().then {
        $0.backgroundColor = UIColor.clear
        $0.tintColor = UIColor.primaryTextColor
    }
    
    let userIdInputTextFieldTitleLabel = UILabel().then {
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 16, weight: .semibold)
    }
    
    let passwordInputTextFieldTitleIcon = UIImageView().then {
        $0.backgroundColor = UIColor.clear
        $0.tintColor = UIColor.primaryTextColor
    }
    
    let passwordInputTextFieldTitleLabel = UILabel().then {
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 16, weight: .semibold)
    }

    let userIdInputTextField = UITextField().then {
        $0.backgroundColor = UIColor.clear
        $0.font = UIFont.notoSansKR(size: 17, weight: .regular)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 4.0, height: 0.0))
        $0.leftViewMode = .always
        $0.clearButtonMode = .whileEditing
        $0.tintColor = UIColor.primaryTextColor
    }
    
    let passwordInputTextField = UITextField().then {
        $0.backgroundColor = UIColor.clear
        $0.font = UIFont.notoSansKR(size: 17, weight: .regular)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 4.0, height: 0.0))
        $0.leftViewMode = .always
        $0.clearButtonMode = .whileEditing
        $0.tintColor = UIColor.primaryTextColor
        $0.isSecureTextEntry = true
    }
    
    let userIdInputTextFieldActiveUnderline = UIView().then {
        $0.backgroundColor = UIColor.SubButtonBackgoundColor
    }
    
    let passwordInputTextFieldActiveUnderline = UIView().then {
        $0.backgroundColor = UIColor.SubButtonBackgoundColor
    }
    
    let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = UIColor.AccentButtonBackgroundColor
        $0.layer.cornerRadius = 20
        $0.clipsToBounds = true
        $0.titleLabel?.font = UIFont.notoSansKR(size: 16, weight: .bold)
        $0.setTitleColor(UIColor.AccentButtonTextColor, for: .normal)
    }
    
    let activityIndicator = UIActivityIndicatorView().then {
        $0.backgroundColor = UIColor.ActivityBackgroundColor
        $0.color = UIColor.ActivityColor
        $0.style = .large
    }
    
    let findAccountButton = UIButton().then {
        $0.backgroundColor = UIColor.clear
        $0.titleLabel?.font = UIFont.notoSansKR(size: 13, weight: .medium)
        $0.setTitleColor(UIColor.UnderlineButtonTextColor, for: .normal)
        $0.sizeToFit()
        
        let title = "회원정보를 까먹으셨나요?"
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )

        $0.setAttributedTitle(attributedTitle, for: .normal)
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
        addSubview(userIdInputTextFieldTitleIcon)
        addSubview(userIdInputTextFieldTitleLabel)
        addSubview(passwordInputTextFieldTitleIcon)
        addSubview(passwordInputTextFieldTitleLabel)
        addSubview(userIdInputTextField)
        addSubview(passwordInputTextField)
        addSubview(userIdInputTextFieldActiveUnderline)
        addSubview(passwordInputTextFieldActiveUnderline)
        addSubview(loginButton)
        addSubview(activityIndicator)
        addSubview(findAccountButton)
        
        activityIndicator.isHidden = true
    }
    
    private func setupConstraints() {
        userIdInputTextFieldTitleIcon.snp.makeConstraints { make in
            make.top.equalTo(140)
            make.leading.equalTo(15)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        userIdInputTextFieldTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userIdInputTextFieldTitleIcon).offset(-1)
            make.leading.equalTo(userIdInputTextFieldTitleIcon.snp.trailing).offset(5)
        }
        
        userIdInputTextField.snp.makeConstraints { make in
            make.top.equalTo(userIdInputTextFieldTitleIcon.snp.bottom).offset(10)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(40)
        }
        
        userIdInputTextFieldActiveUnderline.snp.makeConstraints { make in
            make.top.equalTo(userIdInputTextField.snp.bottom)
            make.leading.equalTo(userIdInputTextField)
            make.trailing.equalTo(userIdInputTextField)
            make.height.equalTo(1)
        }

        passwordInputTextFieldTitleIcon.snp.makeConstraints { make in
            make.top.equalTo(userIdInputTextFieldActiveUnderline.snp.bottom).offset(20)
            make.leading.equalTo(15)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        passwordInputTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordInputTextFieldTitleIcon.snp.bottom).offset(10)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(40)
        }
        
        passwordInputTextFieldTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(passwordInputTextFieldTitleIcon).offset(-1)
            make.leading.equalTo(passwordInputTextFieldTitleIcon.snp.trailing).offset(5)
        }
        
        passwordInputTextFieldActiveUnderline.snp.makeConstraints { make in
            make.top.equalTo(passwordInputTextField.snp.bottom)
            make.leading.equalTo(passwordInputTextField)
            make.trailing.equalTo(passwordInputTextField)
            make.height.equalTo(1)
        }
        
        findAccountButton.snp.makeConstraints { make in
            make.top.equalTo(passwordInputTextFieldActiveUnderline.snp.bottom).offset(15)
            make.leading.equalTo(passwordInputTextField)

        }
         
        loginButton.snp.makeConstraints { make in
            make.bottom.equalTo(-40)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 360, height: 40))
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(userIdImage: UIImage, passwordImage: UIImage, userIdInputTextFieldTitleLabelText: String, passwordInputTextFieldTitleIconText: String, userIdInputTextFieldPlaceholder: String, passwordInputTextFieldPlaceholder: String) {
        userIdInputTextFieldTitleIcon.image = userIdImage
        passwordInputTextFieldTitleIcon.image = passwordImage
        userIdInputTextFieldTitleLabel.text = userIdInputTextFieldTitleLabelText
        passwordInputTextFieldTitleLabel.text = passwordInputTextFieldTitleIconText
        userIdInputTextField.placeholder = userIdInputTextFieldPlaceholder
        passwordInputTextField.placeholder = passwordInputTextFieldPlaceholder
    }
}
