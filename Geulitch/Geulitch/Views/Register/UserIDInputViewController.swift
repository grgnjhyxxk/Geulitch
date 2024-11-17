//
//  UserIDInputViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/9/24.
//

import UIKit

class UserIDInputViewController: BaseRegisterViewController, UITextFieldDelegate {
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
        circularProgressBar = registerView.circularProgressBar
        registerView.textField.delegate = self
        registerView.textField.keyboardType = .asciiCapable
    }
    
    private func configureRegistraion() {
        let step = RegistrationConfig.userId

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

        if let id = registerView.textField.text?.lowercased() {
            let isNumeric = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: id))
            if isNumeric {
                print("아이디는 숫자로만 구성될 수 없습니다.")
                self.registerView.textFieldActiveUnderline.backgroundColor = .systemRed
                return
            }
            
            registerView.activityIndicator.isHidden = false
            registerView.activityIndicator.startAnimating()
            
            viewModel?.checkIfUsernameExists(username: id) { isDuplicate in
                if isDuplicate {
                    print("중복된 아이디입니다.")
                    self.registerView.textFieldActiveUnderline.backgroundColor = .systemRed
                } else {
                    print("사용 가능한 아이디입니다.")
                    self.viewModel?.updateUserId(id)
                    let passwordInputVC = PasswordInputViewController()
                    passwordInputVC.viewModel = self.viewModel
                    self.navigationController?.pushViewController(passwordInputVC, animated: true)
                }
                
                self.registerView.activityIndicator.stopAnimating()
                self.registerView.activityIndicator.isHidden = true
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
        
        // 허용되는 문자 집합 정의
        let allowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.")
        let characterSet = CharacterSet(charactersIn: string)
        
        // 유효하지 않은 문자나 20자 초과를 막는 조건
        if !allowedCharacters.isSuperset(of: characterSet) || prospectiveText.count > 20 {
            return false
        }
        
        // .이 처음이나 끝에 오면 버튼을 비활성화
        let isInvalidPrefixOrSuffix = prospectiveText.hasPrefix(".") || prospectiveText.hasSuffix(".")
        registerView.nextButton.isEnabled = !isInvalidPrefixOrSuffix
        
        // 텍스트가 변경되었을 때 다음 버튼 색상과 상태 업데이트
        let changeBool = prospectiveText.count > 0 && !isInvalidPrefixOrSuffix
        UIView.animate(withDuration: 0.2, animations: {
            self.registerView.textFieldActiveUnderline.backgroundColor = changeBool ? UIColor.AccentButtonBackgroundColor : UIColor.SubButtonBackgoundColor
        })

        registerView.nextButton.backgroundColor = changeBool ? UIColor.AccentButtonBackgroundColor : UIColor.systemGray
        
        // 최대 문자 수에 대한 진행 표시 업데이트
        if let maxCharacterLimit = maxCharacterLimit {
            let progress = min(1.0, CGFloat(prospectiveText.count) / CGFloat(maxCharacterLimit))
            registerView.circularProgressBar.updateProgress(to: progress)
            registerView.textLimitCountLabel.text = "\(maxCharacterLimit - prospectiveText.count)"
        }

        return true
    }
}
