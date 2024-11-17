//
//  LaunchViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/7/24.
//

import SnapKit
import Then
import FirebaseFirestore

class LaunchViewController: UIViewController {
    private let launchView = LaunchView()
    private let viewModel = LaunchViewModel()

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

        // 자동 로그인 수행
        viewModel.autoLogin { [weak self] isLoggedIn in
            guard let self = self else { return }
            if isLoggedIn {
                // 사용자 정보 패치
                self.viewModel.fetchLoggedInUser { result in
                    switch result {
                    case .success(let user):
                        LoggedInUserManager.shared.setLoggedInUser(user)
                        print("User fetched successfully: \(user)")
                        self.switchToTabBarController()
                    case .failure(let error):
                        // 사용자 정보 패치 실패 시 로그인 화면으로 전환
                        print("Failed to fetch user: \(error.localizedDescription)")
                        self.switchToAuthenticationViewController()
                    }
                }
            } else {
                // 로그인 화면으로 전환
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.switchToAuthenticationViewController()
                }
            }
        }

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
                // 애니메이션 완료 후 추가 동작 필요 없음
            }
        })
    }
    
    private func animateAppNameLabel() {
        UIView.animate(withDuration: 0.5, animations: {
            self.launchView.appNameLabel.alpha = 1
        })
    }
    
    private func switchToAuthenticationViewController() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first {
            let authViewController = UINavigationController(rootViewController: AuthenticationViewController())
            
            window.rootViewController = authViewController
            window.makeKeyAndVisible()
            
            UIView.transition(with: window, duration: 0.2, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
    
    private func switchToTabBarController() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first {
            let tabBarController = TabBarController()
            
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
            
            UIView.transition(with: window, duration: 0.2, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
