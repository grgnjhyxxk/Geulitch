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
    let republicOfKoreaCodeLabel = UILabel().then {
        $0.text = "+82"
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 17, weight: .semibold)
    }
    
    let textLimitCountLabel = UILabel().then {
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 14, weight: .medium)
    }
    
    let timeLimitCountLabel = UILabel().then {
        $0.text = "3:00"
        $0.textColor = UIColor.systemRed
        $0.font = UIFont.notoSansKR(size: 17, weight: .semibold)
    }
    
    let titleIcon = UIImageView().then {
        $0.backgroundColor = UIColor.clear
        $0.tintColor = UIColor.primaryTextColor
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 16, weight: .semibold)
    }

    let textField = UITextField().then {
        $0.backgroundColor = UIColor.clear
        $0.font = UIFont.notoSansKR(size: 17, weight: .regular)
        $0.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 4.0, height: 0.0))
        $0.leftViewMode = .always
        $0.clearButtonMode = .whileEditing
        $0.tintColor = UIColor.primaryTextColor
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
        $0.isEnabled = false
    }
    
    let reverificationButton = UIButton().then {
        $0.backgroundColor = UIColor.systemGray
        $0.layer.cornerRadius = 17.5
        $0.setTitle("재인증", for: .normal)
        $0.setTitleColor(UIColor.AccentButtonTextColor, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansKR(size: 15, weight: .semibold)
        $0.isEnabled = false
    }
    
    let activityIndicator = UIActivityIndicatorView().then {
        $0.backgroundColor = UIColor.ActivityBackgroundColor
        $0.color = UIColor.ActivityColor
        $0.style = .large
    }
    
    let circularProgressBar = CircularProgressBar()
    
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
        addSubview(reverificationButton)
        addSubview(circularProgressBar)
        addSubview(activityIndicator)
        
        textField.addSubview(republicOfKoreaCodeLabel)
        textField.addSubview(timeLimitCountLabel)
        circularProgressBar.addSubview(textLimitCountLabel)
        republicOfKoreaCodeLabel.isHidden = true
        timeLimitCountLabel.isHidden = true
        reverificationButton.isHidden = true
        activityIndicator.isHidden = true
    }
    
    private func setupConstraints() {
        titleIcon.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
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
        
        reverificationButton.snp.makeConstraints { make in
            make.bottom.equalTo(-40)
            make.leading.equalTo(15)
            make.size.equalTo(CGSize(width: 70, height: 35))
        }
        
        circularProgressBar.snp.makeConstraints { make in
            make.centerY.equalTo(nextButton)
            make.trailing.equalTo(nextButton.snp.leading).offset(-15)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        
        textLimitCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-1)
        }
        
        republicOfKoreaCodeLabel.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
        }

        timeLimitCountLabel.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(titleIconImage: UIImage, titleLabelText: String, textFieldPlaceholder: String, textFieldExplainLabelText: String, textLimitCountLabelText: String) {
        titleIcon.image = titleIconImage
        titleLabel.text = titleLabelText
        textField.placeholder = textFieldPlaceholder
        textFieldExplainLabel.text = textFieldExplainLabelText
        textLimitCountLabel.text = textLimitCountLabelText
    }
}

class CircularProgressBar: UIView {
    private let progressLayer = CAShapeLayer()
    private let trackLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupCircularPath()  // 뷰 크기에 맞게 경로를 다시 설정
    }

    private func setupProgressBar() {
        // trackLayer와 progressLayer 추가
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = UIColor.systemGray.cgColor
        trackLayer.lineWidth = 3
        layer.addSublayer(trackLayer)
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor.ActivityColor.cgColor
        progressLayer.lineWidth = 3
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
        
        setupCircularPath()  // 초기 경로 설정
    }

    private func setupCircularPath() {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = min(bounds.width, bounds.height) / 2 - progressLayer.lineWidth / 2

        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -CGFloat.pi / 2,
            endAngle: 3 * CGFloat.pi / 2,
            clockwise: true
        )

        trackLayer.path = circularPath.cgPath
        progressLayer.path = circularPath.cgPath
    }

    func updateProgress(to value: CGFloat) {
        progressLayer.strokeEnd = value
    }
}
