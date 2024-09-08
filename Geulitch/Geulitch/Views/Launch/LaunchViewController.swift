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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.primaryBackgroundColor
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
        let authViewController = UINavigationController(rootViewController: AuthenticationViewController())
        
        window.rootViewController = authViewController
        window.makeKeyAndVisible()

        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}
