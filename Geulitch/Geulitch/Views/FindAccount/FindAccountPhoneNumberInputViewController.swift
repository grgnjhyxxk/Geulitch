//
//  FindAccountPhoneNumberInputViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/5/24.
//

import UIKit

class FindAccountPhoneNumberInputViewController: PhoneNumberInputViewController {
    var childViewModel: FindAccoutViewModel? = FindAccoutViewModel()
    
    @objc override func buttonTouched() {
//        let findAccountVerficationCodeVC = FindAccountVerficationCodeViewController()
//        self.navigationController?.pushViewController(findAccountVerficationCodeVC, animated: true)
        
        impactFeedbackgenerator.impactOccurred()
        
        let registerView = getRegisterView()
        
        if let phoneNumber = registerView.textField.text {
            print(phoneNumber)
            
            registerView.activityIndicator.isHidden = false
            registerView.activityIndicator.startAnimating()
            
            self.childViewModel?.updatePhoneNumber(phoneNumber)
                
            self.childViewModel?.sendVerificationCode{ [weak self] verificationID in
                guard let self = self else { return }
                
                registerView.activityIndicator.stopAnimating()
                registerView.activityIndicator.isHidden = true
                
                if let verifiactionID = verificationID {
                    let findAccountVerficationCodeVC = FindAccountVerficationCodeViewController()
                    findAccountVerficationCodeVC.childViewModel = self.childViewModel
                    UserDefaults.standard.set(verificationID, forKey: "verificationID")
                    self.navigationController?.pushViewController(findAccountVerficationCodeVC, animated: true)
                } else {
                    print("인증번호 전송 실패")
                }
            }
        }
    }
}
