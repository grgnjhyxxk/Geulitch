//
//  UserIDInputViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/9/24.
//

import UIKit

class UserIDInputViewController: BaseRegisterViewController, UITextFieldDelegate {
    private let registerView = RegisterView()
    var viewModel: RegisterViewModel?

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
        view.addSubview(registerView)
        
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
    }
    
    private func addTargets() {
        registerView.nextButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction() {
        impactFeedbackgenerator.impactOccurred()

        if let id = registerView.textField.text {
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
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        let allowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.")
        let characterSet = CharacterSet(charactersIn: string)
        
        if !allowedCharacters.isSuperset(of: characterSet) || prospectiveText.count > 30 {
            return false
        }
        
        if prospectiveText.hasPrefix(".") || prospectiveText.hasSuffix(".") {
            return false
        }

        if let maxCharacterLimit = maxCharacterLimit {
            let progress = min(1.0, CGFloat(prospectiveText.count) / CGFloat(maxCharacterLimit))
            registerView.circularProgressBar.updateProgress(to: progress)
            registerView.textLimitCountLabel.text = "\(maxCharacterLimit-prospectiveText.count)"
        }
        
        let changeBool = prospectiveText.count > 0
        UIView.animate(withDuration: 0.2, animations: {
            self.registerView.textFieldActiveUnderline.backgroundColor = changeBool ? UIColor.AccentButtonBackgroundColor : UIColor.SubButtonBackgoundColor
        })

        registerView.nextButton.isEnabled = changeBool
        registerView.nextButton.backgroundColor = changeBool ? UIColor.AccentButtonBackgroundColor : UIColor.systemGray

        return true
    }
}
