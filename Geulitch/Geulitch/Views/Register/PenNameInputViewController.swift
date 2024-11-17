//
//  PenNameInputViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/9/24.
//

import UIKit

class PenNameInputViewController: BaseRegisterViewController, UITextFieldDelegate {
    let registerView = RegisterView()
    var viewModel: RegisterViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setUpIfEditProfileInfo()
        configureRegistraion()
        addTargets()
    }

    func setUpIfEditProfileInfo() { }
    
    private func setupView() {
        view.addSubview(registerView)
        
        navigationItem.title = "회원가입"

        registerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
                
        nextButton = registerView.nextButton
        nextButton?.setTitle("완료", for: .normal)
        circularProgressBar = registerView.circularProgressBar
        registerView.textField.delegate = self
    }
    
    private func configureRegistraion() {
        let step = RegistrationConfig.penName

        let titleIconImage = step.titleIconImage ?? UIImage()
        registerView.configure(
            titleIconImage: titleIconImage,
            titleLabelText: step.titleLabelText,
            textFieldPlaceholder: step.textFieldPlaceholder,
            textFieldExplainLabelText: step.textFieldExplainLabelText,
            textLimitCountLabelText: "\(step.maxCharacterLimit)"
        )
        
        maxCharacterLimit = step.maxCharacterLimit
        
        if let maxCharacterLimit = maxCharacterLimit, let text = registerView.textField.text, !text.isEmpty {
            let progress = min(1.0, CGFloat(text.count) / CGFloat(maxCharacterLimit))
            registerView.circularProgressBar.updateProgress(to: progress)
            registerView.textLimitCountLabel.text = "\(maxCharacterLimit-text.count)"
        }
    }
    
    private func addTargets() {
        registerView.nextButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction() {
        impactFeedbackgenerator.impactOccurred()
        
        if let penName = registerView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            viewModel?.updatePenName(penName)
            
            registerView.activityIndicator.isHidden = false
            registerView.activityIndicator.startAnimating()

            viewModel?.signUp { result in
                switch result {
                case .success:
                    print("회원가입 성공!")
                    
                    self.viewModel?.fetchLoggedInUser { result in
                        switch result {
                        case .success(let user):
                            LoggedInUserManager.shared.setLoggedInUser(user)
                            
                            self.registerView.activityIndicator.stopAnimating()
                            self.registerView.activityIndicator.isHidden = true
                            
                            print("User fetched successfully: \(user)")
                            
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first {
                                let mainFeedViewController = TabBarController()
                                
                                mainFeedViewController.view.alpha = 0.0
                                mainFeedViewController.modalPresentationStyle = .fullScreen
                                
                                window.backgroundColor = UIColor.clear
                                window.rootViewController = TabBarController()
                                window.makeKeyAndVisible()
                                
                                UIView.animate(withDuration: 1.0) {
                                    mainFeedViewController.view.alpha = 1.0
                                }
                            }
                        case .failure(let error):
                            // 사용자 정보 패치 실패 시 로그인 화면으로 전환
                            print("Failed to fetch user: \(error.localizedDescription)")
                            
                            self.registerView.activityIndicator.stopAnimating()
                            self.registerView.activityIndicator.isHidden = true
                        }
                    }
                case .failure(let error):
                    print("회원가입 실패: \(error.localizedDescription)")
                    
                    self.registerView.activityIndicator.stopAnimating()
                    self.registerView.activityIndicator.isHidden = true
                }
            }
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("textField clear")
        
        if let maxCharacterLimit = maxCharacterLimit {
            let progress = min(1.0, CGFloat(maxCharacterLimit))
            registerView.circularProgressBar.updateProgress(to: progress)
            registerView.textLimitCountLabel.text = "\(maxCharacterLimit)"
        }
        
        registerView.nextButton.isEnabled = false
        registerView.nextButton.backgroundColor = UIColor.systemGray

        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if prospectiveText.count > 20 {
            return false
        }

        if let maxCharacterLimit = maxCharacterLimit {
            let progress = min(1.0, CGFloat(prospectiveText.count) / CGFloat(maxCharacterLimit))
            registerView.circularProgressBar.updateProgress(to: progress)
            registerView.textLimitCountLabel.text = "\(maxCharacterLimit - prospectiveText.count)"
        }
        
        // 공백만 있는지 검사
        let isOnlyWhitespace = prospectiveText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        UIView.animate(withDuration: 0.2, animations: {
            self.registerView.textFieldActiveUnderline.backgroundColor = isOnlyWhitespace ? UIColor.SubButtonBackgoundColor : UIColor.AccentButtonBackgroundColor
        })

        // 공백만 있는 경우 버튼 비활성화
        registerView.nextButton.isEnabled = !isOnlyWhitespace
        registerView.nextButton.backgroundColor = isOnlyWhitespace ? UIColor.systemGray : UIColor.AccentButtonBackgroundColor

        return true
    }
}
