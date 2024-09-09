//
//  RegisterView.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/8/24.
//

import UIKit
import Then
import SnapKit

class RegisterView: UIView {
    let titleIcon = UIImageView().then {
        $0.backgroundColor = UIColor.clear
        $0.tintColor = UIColor.primaryTextColor
    }
    
    let titleLabel = UITextField().then {
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 16, weight: .semibold)
    }

    let textField = UITextField().then {
        $0.backgroundColor = UIColor.clear
        $0.font = UIFont.notoSansKR(size: 17, weight: .regular)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 4.0, height: 0.0))
        $0.leftViewMode = .always
        $0.keyboardType = .numberPad
        $0.clearButtonMode = .whileEditing
        $0.tintColor = UIColor.primaryTextColor
        $0.isEnabled = false
    }
    
    let textFieldActiveUnderline = UIView().then {
        $0.backgroundColor = UIColor.SubButtonBackgoundColor
    }
    
    let textFieldExplainLabel = UILabel().then {
        $0.textColor = UIColor.SubLabelTextColor
        $0.font = UIFont.notoSansKR(size: 13, weight: .medium)
        $0.numberOfLines = 0
    }
    
    let nextButton = UIButton().then {
        $0.backgroundColor = UIColor.systemGray
        $0.layer.cornerRadius = 17.5
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor.AccentButtonTextColor, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansKR(size: 15, weight: .semibold)
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
        addSubview(titleIcon)
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(textFieldActiveUnderline)
        addSubview(textFieldExplainLabel)
        addSubview(nextButton)
    }
    
    private func setupConstraints() {
        titleIcon.snp.makeConstraints { make in
            make.top.equalTo(140)
            make.leading.equalTo(15)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleIcon).offset(-1)
            make.leading.equalTo(titleIcon.snp.trailing).offset(5)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleIcon.snp.bottom).offset(10)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(40)
        }
        
        textFieldActiveUnderline.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.equalTo(textField)
            make.trailing.equalTo(textField)
            make.height.equalTo(1)
        }
        
        textFieldExplainLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldActiveUnderline.snp.bottom).offset(10)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(-40)
            make.trailing.equalTo(-15)
            make.size.equalTo(CGSize(width: 60, height: 35))
        }
    }
    
    func configure(titleIconImage: UIImage, titleLabelText: String, textFieldPlaceholder: String, textFieldExplainLabelText: String) {
        titleIcon.image = titleIconImage
        titleLabel.text = titleLabelText
        textField.placeholder = textFieldPlaceholder
        textFieldExplainLabel.text = textFieldExplainLabelText
    }
}
