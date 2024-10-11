//
//  FoundIDViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/5/24.
//

import UIKit

class FoundIDViewController: UIViewController {
    private let findAccountView = FindAccountView()
    var childViewModel: FindAccoutViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureRegistraion()
        addTargets()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.primaryBackground

        navigationItem.title = "FOUND ID"

        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor.primaryLabelText
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        view.addSubview(findAccountView)
        
        findAccountView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureRegistraion() {
        if let userAccount = childViewModel?.getUserAccount() {
            let userID = userAccount.userID
            let userProfileImage = userAccount.userProfileImage
            
            print("사용자 계정 정보: 아이디(\(userID))")
            findAccountView.configure(
                userID: userID,
                userProfileImage: userProfileImage
            )
        } else {
            // 사용자 계정 정보가 없을 때의 처리
            print("사용자 계정 정보가 없습니다.")
            findAccountView.configure(
                userID: "Unknown?",
                userProfileImage: UIImage.defaultUserProfile
            )
        }
    }
    
    private func addTargets() {
        findAccountView.resetPasswordButton.addTarget(self, action: #selector(resetPasswordButtonAction), for: .touchUpInside)
        findAccountView.goToLoginButton.addTarget(self, action: #selector(goToLoginButtonAction), for: .touchUpInside)
    }
    
    @objc private func resetPasswordButtonAction() {
        let resetPasswordVC = ResetPasswordViewController()
        
        resetPasswordVC.childViewModel = childViewModel
        
        navigationController?.pushViewController(resetPasswordVC, animated: true)
    }
    
    @objc private func goToLoginButtonAction() {
        if let viewControllers = navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is LoginViewController { // BViewController를 찾으면
                    navigationController?.popToViewController(viewController, animated: true) // B로 pop
                    break
                }
            }
        }
    }
}
