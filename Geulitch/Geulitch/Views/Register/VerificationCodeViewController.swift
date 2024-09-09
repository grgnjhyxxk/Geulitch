//
//  VerificationCodeViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/8/24.
//

import UIKit

class VerificationCodeViewController: BaseRegisterViewController {
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
                
        self.nextButton = registerView.nextButton
    }
    
    private func configureRegistraion() {
        let step = RegistrationConfig.verificationCode

        let titleIconImage = step.titleIconImage ?? UIImage()
        registerView.configure(
            titleIconImage: titleIconImage,
            titleLabelText: step.titleLabelText,
            textFieldPlaceholder: step.textFieldPlaceholder,
            textFieldExplainLabelText: step.textFieldExplainLabelText
        )
        
        registerView.titleIcon.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: 28, height: 24))
        }
    }
    
    private func addTargets() {
        registerView.nextButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction() {
        self.navigationController?.pushViewController(UserIDInputViewController(), animated: true)
    }
}
