//
//  PenNameInputViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/9/24.
//

import UIKit

class PenNameInputViewController: BaseRegisterViewController, UITextFieldDelegate {
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
    }
    
    private func addTargets() {
        registerView.nextButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction() {
        navigationController?.popToRootViewController(animated: true)
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
            registerView.textLimitCountLabel.text = "\(maxCharacterLimit-prospectiveText.count)"
        }
        
        let changeBool = prospectiveText.count >= 0
        UIView.animate(withDuration: 0.2, animations: {
            self.registerView.textFieldActiveUnderline.backgroundColor = changeBool ? UIColor.AccentButtonBackgroundColor : UIColor.SubButtonBackgoundColor
        })

        registerView.nextButton.isEnabled = changeBool
        registerView.nextButton.backgroundColor = changeBool ? UIColor.AccentButtonBackgroundColor : UIColor.systemGray

        return true
    }
}
