//
//  LaunchView.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/7/24.
//

import UIKit
import SnapKit
import Then

class LaunchView: UIView {
    let appIconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    let appNameLabel = UILabel().then {
        $0.textColor = UIColor.white
        $0.font = UIFont.notoSansKR(size: 20, weight: .bold)
        $0.alpha = 0
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
        addSubview(appIconImageView)
        addSubview(appNameLabel)
    }
    
    private func setupConstraints() {
        appIconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        appNameLabel.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    
    func configureAppIconImageView(with image: UIImage?) {
        appIconImageView.image = image
    }
    
    func configureAppNameLabel() {
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            appNameLabel.text = appName
        }
    }
}
