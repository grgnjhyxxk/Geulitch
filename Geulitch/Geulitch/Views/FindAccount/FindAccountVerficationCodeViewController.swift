//
//  FindAccountVerficationCodeViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/5/24.
//

import UIKit

class FindAccountVerficationCodeViewController: VerificationCodeViewController {
    var childViewModel: FindAccoutViewModel?

    @objc override func buttonAction() {
//        let foundIDVC = FoundIDViewController()
//        self.navigationController?.pushViewController(foundIDVC, animated: true)
        
        impactFeedbackgenerator.impactOccurred()
        
        let registerView = getRegisterView()

        let verificationID = UserDefaults.standard.string(forKey: "verificationID") ?? ""
        
        if let verificationCode = registerView.textField.text {
            registerView.activityIndicator.isHidden = false
            registerView.activityIndicator.startAnimating()
                
            childViewModel?.verifyCode(verificationID: verificationID, verificationCode: verificationCode) { [weak self] result in
                switch result {
                case .success(let user):
                    print("인증 성공: \(user.uid)")
                    
                    self?.childViewModel?.fetchUserData() { [weak self] result in
                        switch result {
                        case .success(let (userDocument, userID, userProfileImage)):
                            print("유저 데이터 가져오기 성공")
                            self?.childViewModel?.updateUserId(userID)
                            self?.childViewModel?.updateUserProfileImage(userProfileImage)
                            self?.childViewModel?.updateUserDocument(userDocument)
                            
                            let foundIDVC = FoundIDViewController()
                            foundIDVC.childViewModel = self?.childViewModel

                            // 현재 스택에서 인증 뷰 컨트롤러 제거 후 새로운 뷰 컨트롤러로 대체
                            if var viewControllers = self?.navigationController?.viewControllers {
                                viewControllers.removeLast() // 현재 인증 뷰 컨트롤러 제거
                                viewControllers.append(foundIDVC) // ID 찾기 뷰 컨트롤러 추가
                                self?.navigationController?.setViewControllers(viewControllers, animated: true) // 새로운 스택 설정
                            }
                        case .failure(let error):
                            print("유저 데이터 가져오기 실패: \(error.localizedDescription)")
                        }
                    }
                case .failure(let error):
                    print("인증 실패: \(error.localizedDescription)")
                    registerView.textFieldActiveUnderline.backgroundColor = .systemRed
                }
                
                registerView.activityIndicator.stopAnimating()
                registerView.activityIndicator.isHidden = true
            }
        }
    }
    
    @objc override func reverificationButtonAction() {
        impactFeedbackgenerator.impactOccurred()
        
        let registerView = getRegisterView()
        
        registerView.activityIndicator.isHidden = false
        registerView.activityIndicator.startAnimating()
        
        childViewModel?.sendVerificationCode { [weak self] verificationID in
            guard let verificationID = verificationID else { return }
            
            UserDefaults.standard.set(verificationID, forKey: "verificationID")
            registerView.reverificationButton.backgroundColor = UIColor.systemGray
            self?.reverificationButton?.isEnabled = false
            registerView.textField.isEnabled = true
            self?.resetTotalTime()
            
            registerView.activityIndicator.stopAnimating()
            registerView.activityIndicator.isHidden = true
        }
    }
}
