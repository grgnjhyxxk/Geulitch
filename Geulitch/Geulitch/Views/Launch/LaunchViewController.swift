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
        autoLogin { [weak self] isLoggedIn in
            if isLoggedIn {
                self?.switchToTabBarController()
            } else {
                // 로그인 화면으로 전환
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self?.switchToAuthenticationViewController()
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

    // 자동 로그인 함수
    private func autoLogin(completion: @escaping (Bool) -> Void) {
        // UserDefaults에서 자동 로그인 정보 가져오기
        guard let phoneNumber = UserDefaults.standard.string(forKey: "autoLoginPhoneNumber"),
              let password = UserDefaults.standard.string(forKey: "autoLoginPassword") else {
            completion(false) // 자동 로그인 정보가 없으므로 로그인 실패
            return
        }
        
        // 전화번호로 사용자 문서 찾기
        let db = Firestore.firestore()
        db.collection("users").whereField("phoneNumber", isEqualTo: phoneNumber).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                completion(false) // 오류 발생 시 로그인 실패
                return
            }
            
            guard let documents = snapshot?.documents, let document = documents.first else {
                completion(false) // 문서가 없으면 로그인 실패
                return
            }
            
            // 유저 문서가 존재하고 비밀번호가 일치하는지 확인
            guard let storedPassword = document.data()["password"] as? String else {
                completion(false) // 비밀번호 정보가 없으면 로그인 실패
                return
            }
            
            // 비밀번호 비교
            if storedPassword == password {
                completion(true) // 비밀번호가 일치하면 로그인 성공
            } else {
                completion(false) // 비밀번호가 일치하지 않으면 로그인 실패
            }
        }
    }
}
