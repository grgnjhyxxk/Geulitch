//
//  AuthenticationViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/7/24.
//

import SnapKit
import Then

class AuthenticationViewController: UIViewController {
    private let authenticationView = AuthenticationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        addTargets()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let color = UIColor.ButtonBorderColor
        let resolvedColor = color.resolvedColor(with: traitCollection)
        
        authenticationView.registerButton.layer.borderColor = resolvedColor.cgColor
        authenticationView.registerButton.layer.borderWidth = 1.0
    }
    
    private func setupNavigation() {
//        let imageViews = UIImageView(image: UIImage.Geulitch_white_on_transparent_icon)
//        
//        navigationItem.titleView = imageViews
//        
//        imageViews.snp.makeConstraints { make in
//            make.size.equalTo(CGSize(width: 34, height: 34))
//        }
        
        let backBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor.primaryLabelText
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.primaryBackgroundColor

        view.addSubview(authenticationView)
        
        authenticationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addTargets() {
        authenticationView.loginButton.addTarget(self, action: #selector(buttonTouched), for: [.touchDown, .touchDragEnter])
        authenticationView.loginButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchCancel, .touchDragExit])
        authenticationView.registerButton.addTarget(self, action: #selector(buttonTouched), for: [.touchDown, .touchDragEnter])
        authenticationView.registerButton.addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }
    
    @objc func buttonTouched(sender: UIButton) {
        switch sender {
        case authenticationView.loginButton:
            sender.backgroundColor = UIColor.AccentButtonBackgroundColorHighlightColor
        case authenticationView.registerButton:
            sender.backgroundColor = UIColor.clear
        default:
            break
        }
    }

    @objc func buttonReleased(sender: UIButton, for event: UIEvent) {
        switch sender {
        case authenticationView.loginButton:
            sender.backgroundColor = UIColor.AccentButtonBackgroundColor
            if let touch = event.allTouches?.first, touch.phase == .ended {
                let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
                impactFeedbackgenerator.impactOccurred()

                let viewController = LoginViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        case authenticationView.registerButton:
            sender.backgroundColor = UIColor.clear
            
            if let touch = event.allTouches?.first, touch.phase == .ended {
                let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
                impactFeedbackgenerator.impactOccurred()

                let viewController = PhoneNumberInputViewController()
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
}
