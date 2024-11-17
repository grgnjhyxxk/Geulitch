//
//  BaseRegisterViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/9/24.
//

import UIKit

class BaseRegisterViewController: UIViewController {
    var nextButton: UIButton?
    var reverificationButton: UIButton?
    var circularProgressBar: CircularProgressBar?
    var maxCharacterLimit: Int?
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBaseView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setUpBaseView() {
        self.view.backgroundColor = UIColor.primaryBackgroundColor
        
        let backBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor.primaryLabelText
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height

            if let nextButton = nextButton, let circularProgressBar = circularProgressBar {
                UIView.animate(withDuration: 0.3) {
                    nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 25)
                    circularProgressBar.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 25)
                    
                    if let reverificationButton = self.reverificationButton {
                        reverificationButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 25)
                    }
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let nextButton = nextButton, let circularProgressBar = circularProgressBar {
            UIView.animate(withDuration: 0.3) {
                nextButton.transform = .identity
                circularProgressBar.transform = .identity
                if let reverificationButton = self.reverificationButton {
                    reverificationButton.transform = .identity
                }
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

