//
//  BaseRegisterViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/9/24.
//

import UIKit

class BaseRegisterViewController: UIViewController {
    var nextButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpBaseView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setUpBaseView() {
        self.view.backgroundColor = UIColor.primaryBackgroundColor

        let imageViews = UIImageView(image: UIImage.Geulitch_white_on_transparent_icon)
        
        imageViews.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 34, height: 34))
        }
                                    
        navigationItem.titleView = imageViews
        
        let backBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor.primaryLabelText
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height

            if let nextButton = nextButton {
                UIView.animate(withDuration: 0.3) {
                    nextButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 25)
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let nextButton = nextButton {
            UIView.animate(withDuration: 0.3) {
                nextButton.transform = .identity
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

