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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.primaryBackground

        navigationItem.title = "LOGIN"
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor.primaryLabelText
        self.navigationItem.backBarButtonItem = backBarButtonItem

        
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
        loginView.findAccountButton.addTarget(self, action: #selector(findAccountButtonTouched), for: .touchUpInside)
    }
    
    @objc private func loginButtonTouched() {
        guard let userIdOrPhoneNumber = loginView.userIdInputTextField.text,
              let password = loginView.passwordInputTextField.text else {
            print("아이디 또는 비밀번호를 입력해주세요.")
            return
        }
        
        // 비밀번호를 해시하고 ViewModel에 전달
        viewModel.setPassword(password)

        // 로그인 시도할 때, 전화번호인지 아이디인지 판단
        let isPhoneNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: userIdOrPhoneNumber))
        
        loginView.activityIndicator.isHidden = false
        loginView.activityIndicator.startAnimating()
        
        // 로그인 호출
        viewModel.login(userIdentifier: userIdOrPhoneNumber, isPhoneNumber: isPhoneNumber) { [weak self] result in
            self?.loginView.activityIndicator.stopAnimating()
            self?.loginView.activityIndicator.isHidden = true
            
            switch result {
            case .success:
                print("\(isPhoneNumber ? "전화번호" : "아이디") 로그인 성공")
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let window = windowScene.windows.first {
                    let tabBarController = TabBarController()
                    
                    window.rootViewController = tabBarController
                    window.makeKeyAndVisible()

                    UIView.transition(with: window, duration: 0.2, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
            case .failure(let error):
                print("로그인 실패: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func findAccountButtonTouched() {
        let findAccountPhoneNumberInputVC = FindAccountPhoneNumberInputViewController()
        
        navigationController?.pushViewController(findAccountPhoneNumberInputVC, animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let loginButton = loginView.loginButton
            
            UIView.animate(withDuration: 0.3) {
                loginButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 25)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let loginButton = loginView.loginButton

        UIView.animate(withDuration: 0.3) {
            loginButton.transform = .identity
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
