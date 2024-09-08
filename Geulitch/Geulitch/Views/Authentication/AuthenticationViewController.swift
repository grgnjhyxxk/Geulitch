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
        setupView()
        addTargets()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.primaryBackgroundColor
        let imageViews = UIImageView(image: UIImage.Geulitch_white_on_transparent_icon)
        
        imageViews.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 34, height: 34))
        }
                                    
        navigationItem.titleView = imageViews
        
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
            sender.backgroundColor = UIColor.SubButtonBackgroundHighlightColor
        default:
            break
        }
        
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackgenerator.impactOccurred()
    }

    @objc func buttonReleased(sender: UIButton) {
        switch sender {
        case authenticationView.loginButton:
            sender.backgroundColor = UIColor.AccentButtonBackgroundColor
        case authenticationView.registerButton:
            sender.backgroundColor = UIColor.SubButtonBackgoundColor
        default:
            break
        }
    }

}
