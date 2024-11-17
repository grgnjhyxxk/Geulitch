//
//  PasswordInputViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/9/24.
//

import UIKit

class PasswordInputViewController: BaseRegisterViewController, UITextFieldDelegate {
    private let registerView = RegisterView()
    var viewModel: RegisterViewModel?

    func setupChildView() {
        
    }
    
    func getRegisterView() -> RegisterView {
        return self.registerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureRegistraion()
        addTargets()
        setupChildView()
    }
    
    private func setupView() {
        view.addSubview(registerView)
        
        navigationItem.title = "회원가입"

        registerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
                
        nextButton = registerView.nextButton
        circularProgressBar = registerView.circularProgressBar
        registerView.textField.isSecureTextEntry = true
        registerView.textField.delegate = self
    }
    
    private func configureRegistraion() {
        let step = RegistrationConfig.password

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
        
        // 비밀번호 해싱 후 ViewModel에 전달
        if let password = registerView.textField.text {
            viewModel?.setPassword(password)
        }
        
        let penNameInputVC = PenNameInputViewController()
        penNameInputVC.viewModel = self.viewModel
        self.navigationController?.pushViewController(penNameInputVC, animated: true)
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
        
        let allowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_-+=[{]};:'\"/?.>,<\\|₩~`")
        let characterSet = CharacterSet(charactersIn: string)
        
        if !allowedCharacters.isSuperset(of: characterSet) || prospectiveText.count > 128 {
            return false
        }

        if let maxCharacterLimit = maxCharacterLimit {
            let progress = min(1.0, CGFloat(prospectiveText.count) / CGFloat(maxCharacterLimit))
            registerView.circularProgressBar.updateProgress(to: progress)
            registerView.textLimitCountLabel.text = "\(maxCharacterLimit-prospectiveText.count)"
        }
        
        let changeBool = prospectiveText.count >= 6
        UIView.animate(withDuration: 0.2, animations: {
            self.registerView.textFieldActiveUnderline.backgroundColor = changeBool ? UIColor.AccentButtonBackgroundColor : UIColor.SubButtonBackgoundColor
        })

        registerView.nextButton.isEnabled = changeBool
        registerView.nextButton.backgroundColor = changeBool ? UIColor.AccentButtonBackgroundColor : UIColor.systemGray

        return true
    }
}
