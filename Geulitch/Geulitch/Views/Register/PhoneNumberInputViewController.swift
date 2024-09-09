//
//  PhoneNumberInputViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/8/24.
//

import UIKit

class PhoneNumberInputViewController: BaseRegisterViewController, UITextFieldDelegate {
    private let registerView = RegisterView()
    
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
        registerView.textField.delegate = self
    }
    
    private func configureRegistraion() {
        let step = RegistrationConfig.phoneNumber

        let titleIconImage = step.titleIconImage ?? UIImage()
        registerView.configure(
            titleIconImage: titleIconImage,
            titleLabelText: step.titleLabelText,
            textFieldPlaceholder: step.textFieldPlaceholder,
            textFieldExplainLabelText: step.textFieldExplainLabelText
        )
    }
    
    private func addTargets() {
        registerView.nextButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction() {
        self.navigationController?.pushViewController(VerificationCodeViewController(), animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updatedText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""

        if updatedText.count > 0 {
            registerView.nextButton.isEnabled = true
            registerView.nextButton.backgroundColor = UIColor.AccentButtonBackgroundColor
        } else {
            registerView.nextButton.isEnabled = false
            registerView.nextButton.backgroundColor = UIColor.systemGray
        }
        
        return true
    }
}
