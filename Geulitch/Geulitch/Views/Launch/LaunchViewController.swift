//
//  LaunchViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/7/24.
//

import SnapKit
import Then

class LaunchViewController: UIViewController {
    private let launchView = LaunchView()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.primaryColor
        view.addSubview(launchView)
        launchView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        launchView.configureAppIconImageView(with: UIImage.Geulitch_white_on_transparent_icon)
        launchView.configureAppNameLabel()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.animateAppIconImageView()
            self?.animateAppNameLabel()
        }
    }
    
    private func animateAppIconImageView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.launchView.appIconImageView.snp.updateConstraints { make in
                make.centerY.equalToSuperview().offset(-30)
            }
            self.view.layoutIfNeeded()
        }, completion: { finished in
            if finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.switchToAuthenticationViewController()
                }
            }
        })
    }
    
    private func animateAppNameLabel() {
        UIView.animate(withDuration: 0.5, animations: {
            self.launchView.appNameLabel.alpha = 1
        })
    }
    
    private func switchToAuthenticationViewController() {
        guard let window = UIApplication.shared.windows.first else { return }
//        let authViewController = AuthenticationViewController()
        
//        window.rootViewController = authViewController
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}
