//
//  ResetPasswordViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/5/24.
//

import UIKit

class ResetPasswordViewController: PasswordInputViewController {
    var childViewModel: FindAccoutViewModel?

    override func setupChildView() {
        navigationItem.title = "NEW PASSWORD"
        nextButton?.setTitle("완료", for: .normal)
    }
    
    @objc override func buttonAction() {
        impactFeedbackgenerator.impactOccurred()

        let registerView = getRegisterView()
        
        registerView.activityIndicator.isHidden = false
        registerView.activityIndicator.startAnimating()
        
        if let newPassword = registerView.textField.text {
            childViewModel?.setNewPassword(newPassword)
            
            childViewModel?.updatePassword { result in
                switch result {
                case .success:
                    print("비밀번호가 성공적으로 업데이트되었습니다.")
                    
                    if let viewControllers = self.navigationController?.viewControllers {
                        for viewController in viewControllers {
                            if viewController is LoginViewController { // BViewController를 찾으면
                                self.navigationController?.popToViewController(viewController, animated: true) // B로 pop
                                break
                            }
                        }
                    }
                case .failure(let error):
                    print("비밀번호 업데이트 중 오류 발생: \(error.localizedDescription)")
                }
            }
            
            registerView.activityIndicator.stopAnimating()
            registerView.activityIndicator.isHidden = true
        }
    }
}
