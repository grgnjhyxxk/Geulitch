//
//  PhoneNumberInputViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/8/24.
//

import UIKit
//import FirebaseAuth

class PhoneNumberInputViewController: BaseRegisterViewController, UITextFieldDelegate {
    private let registerView = RegisterView()
    var viewModel: RegisterViewModel? = RegisterViewModel()

    func getRegisterView() -> RegisterView {
        return self.registerView
    }
    
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
        
        navigationItem.title = "PHONE"

        registerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nextButton = registerView.nextButton
        circularProgressBar = registerView.circularProgressBar
        registerView.textField.delegate = self
        registerView.textField.keyboardType = .numberPad
        registerView.textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 36, height: 0.0))
        registerView.republicOfKoreaCodeLabel.isHidden = false
    }
    
    private func configureRegistraion() {
        let step = RegistrationConfig.phoneNumber

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
        registerView.nextButton.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
    }
    
    @objc func buttonTouched() {
        impactFeedbackgenerator.impactOccurred()
        
//        registerView.activityIndicator.isHidden = false
//        registerView.activityIndicator.startAnimating()
//
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//            let verificationVC = VerificationCodeViewController()
//            verificationVC.viewModel = self.viewModel
//            self.navigationController?.pushViewController(verificationVC, animated: true)
//        }

        if let phoneNumber = registerView.textField.text {
            registerView.activityIndicator.isHidden = false
            registerView.activityIndicator.startAnimating()

            viewModel?.checkIfPhoneNumberExists(phoneNumber: phoneNumber) { [weak self] phoneNumberExists in
                guard let self = self else { return }

                if phoneNumberExists {
                    // 중복된 전화번호가 있으면 처리
                    print("이미 등록된 전화번호입니다.")
                    self.registerView.activityIndicator.stopAnimating()
                    self.registerView.activityIndicator.isHidden = true
                    // 알림 메시지를 띄우는 등 추가 처리 가능
                    return
                }

                // 중복이 없으면 번호 업데이트 후 인증 코드 전송
                self.viewModel?.updatePhoneNumber(phoneNumber)

                self.viewModel?.sendVerificationCode { [weak self] verificationID in
                    guard let self = self else { return }
                    
                    self.registerView.activityIndicator.stopAnimating()
                    self.registerView.activityIndicator.isHidden = true

                    if let verificationID = verificationID {
                        // 인증 뷰컨으로 이동하면서 verificationID 전달
                        let verificationVC = VerificationCodeViewController()
                        verificationVC.viewModel = self.viewModel
                        UserDefaults.standard.set(verificationID, forKey: "verificationID")
                        self.navigationController?.pushViewController(verificationVC, animated: true)
                    } else {
                        // 실패 처리
                        print("인증번호 전송 실패")
                    }
                }
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)

        let allowedCharacters = CharacterSet(charactersIn: "0123456789")
        let characterSet = CharacterSet(charactersIn: string)
        
        if !allowedCharacters.isSuperset(of: characterSet) || prospectiveText.count > 11 {
            return false
        }
        
        let phoneRegex = "^010[0-9]{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        if prospectiveText.count == maxCharacterLimit && predicate.evaluate(with: prospectiveText) {
            registerView.nextButton.isEnabled = true
            registerView.nextButton.backgroundColor = UIColor.AccentButtonBackgroundColor
        } else {
            registerView.nextButton.isEnabled = false
            registerView.nextButton.backgroundColor = UIColor.systemGray
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

        return true
    }
}
