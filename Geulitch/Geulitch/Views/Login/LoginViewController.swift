//
//  LoginViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/2/24.
//

import UIKit
//import FirebaseAuth

class LoginViewController: UIViewController {
    private let loginView = LoginView()
    private let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureRegistraion()
        addTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.primaryBackground
        
        let imageViews = UIImageView(image: UIImage.Geulitch_white_on_transparent_icon)
        
        imageViews.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 34, height: 34))
        }
                                    
        navigationItem.titleView = imageViews
        
        view.addSubview(loginView)
        
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureRegistraion() {
        let userIdStep = LoginConfig.userId
        let passwordStep = LoginConfig.password

        let userIdImage = userIdStep.titleIconImage ?? UIImage()
        let passwordImage = passwordStep.titleIconImage ?? UIImage()

        loginView.configure(
            userIdImage: userIdImage,
            passwordImage: passwordImage,
            userIdInputTextFieldTitleLabelText: userIdStep.titleLabelText,
            passwordInputTextFieldTitleIconText: passwordStep.titleLabelText,
            userIdInputTextFieldPlaceholder: userIdStep.textFieldPlaceholder,
            passwordInputTextFieldPlaceholder: passwordStep.textFieldPlaceholder
        )
    }
    
    private func addTargets() {
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
    }
    
    @objc private func loginButtonTouched() {
        guard let userIdOrPhoneNumber = loginView.userIdInputTextField.text,
              let password = loginView.passwordInputTextField.text else {
            print("아이디 또는 비밀번호를 입력해주세요.")
            return
        }
        
        // 비밀번호를 해시하고 ViewModel에 전달
        viewModel.setPassword(password)
        
        // 입력된 값이 숫자이면 전화번호로 처리
        if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: userIdOrPhoneNumber)) {
            // 전화번호로 로그인 시도
            loginView.activityIndicator.isHidden = false
            loginView.activityIndicator.startAnimating()
            
            viewModel.updatePhoneNumber(userIdOrPhoneNumber)
            viewModel.loginWithPhoneNumber { [weak self] result in
                switch result {
                case .success:
                    print("전화번호 로그인 성공")
                    // 로그인 성공 처리 (예: 다음 화면으로 이동)
                case .failure(let error):
                    print("로그인 실패: \(error.localizedDescription)")
                }
                
                self?.loginView.activityIndicator.stopAnimating()
                self?.loginView.activityIndicator.isHidden = true
            }
        } else {
            // 아이디로 로그인 시도
            loginView.activityIndicator.isHidden = false
            loginView.activityIndicator.startAnimating()
            
            viewModel.updateUserId(userIdOrPhoneNumber)
            viewModel.login { [weak self] result in
                switch result {
                case .success:
                    print("아이디 로그인 성공")
                    // 로그인 성공 처리 (예: 다음 화면으로 이동)
                case .failure(let error):
                    print("로그인 실패: \(error.localizedDescription)")
                }
                
                self?.loginView.activityIndicator.stopAnimating()
                self?.loginView.activityIndicator.isHidden = true
            }
        }
    }
}
