//
//  VerificationCodeViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/8/24.
//

import UIKit
//import FirebaseAuth

class VerificationCodeViewController: BaseRegisterViewController, UITextFieldDelegate {
    private let registerView = RegisterView()
    private var timer: Timer?
    private var totalTimeInSeconds: Int = 180
    var viewModel: RegisterViewModel?

    func getRegisterView() -> RegisterView {
        return self.registerView
    }
    
    func resetTotalTime() {
        totalTimeInSeconds = 180
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configureRegistraion()
        addTargets()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupView() {
        view.addSubview(registerView)
        
        navigationItem.title = "CHECK"

        registerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
                
        nextButton = registerView.nextButton
        reverificationButton = registerView.reverificationButton
        circularProgressBar = registerView.circularProgressBar
        registerView.textField.delegate = self
        registerView.textField.keyboardType = .numberPad
        registerView.textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 42, height: 0.0))
        registerView.timeLimitCountLabel.isHidden = false
        registerView.reverificationButton.isHidden = false
    }
    
    private func configureRegistraion() {
        let step = RegistrationConfig.verificationCode

        let titleIconImage = step.titleIconImage ?? UIImage()
        registerView.configure(
            titleIconImage: titleIconImage,
            titleLabelText: step.titleLabelText,
            textFieldPlaceholder: step.textFieldPlaceholder,
            textFieldExplainLabelText: step.textFieldExplainLabelText,
            textLimitCountLabelText: "\(step.maxCharacterLimit)"
        )
        
        registerView.titleIcon.snp.updateConstraints { make in
            make.size.equalTo(CGSize(width: 28, height: 24))
        }
        
        maxCharacterLimit = step.maxCharacterLimit
    }
    
    private func addTargets() {
        registerView.nextButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        registerView.reverificationButton.addTarget(self, action: #selector(reverificationButtonAction), for: .touchUpInside)
    }
    
    @objc func buttonAction() {
        impactFeedbackgenerator.impactOccurred()

        let verificationID = UserDefaults.standard.string(forKey: "verificationID") ?? ""
        
        if let verificationCode = registerView.textField.text {
            registerView.activityIndicator.isHidden = false
            registerView.activityIndicator.startAnimating()
            
            viewModel?.verifyCode(verificationID: verificationID, verificationCode: verificationCode) { [weak self] result in
                switch result {
                case .success(let user):
                    print("인증 성공: \(user.uid)")
                    let userIDInputVC = UserIDInputViewController()
                    userIDInputVC.viewModel = self?.viewModel
                    self?.navigationController?.pushViewController(userIDInputVC, animated: true)
                case .failure(let error):
                    print("인증 실패: \(error.localizedDescription)")
                    self?.registerView.textFieldActiveUnderline.backgroundColor = .systemRed
                }
                
                self?.registerView.activityIndicator.stopAnimating()
                self?.registerView.activityIndicator.isHidden = true
            }
        }
        
//        let userIDInputVC = UserIDInputViewController()
//        userIDInputVC.viewModel = viewModel
//        navigationController?.pushViewController(userIDInputVC, animated: true)
    }
    
    @objc func reverificationButtonAction() {
        impactFeedbackgenerator.impactOccurred()
        
        registerView.activityIndicator.isHidden = false
        registerView.activityIndicator.startAnimating()
        
        viewModel?.sendVerificationCode { [weak self] verificationID in
            guard let verificationID = verificationID else { return }

            UserDefaults.standard.set(verificationID, forKey: "verificationID")
            self?.registerView.reverificationButton.backgroundColor = UIColor.systemGray
            self?.reverificationButton?.isEnabled = false
            self?.registerView.textField.isEnabled = true
            self?.resetTotalTime()
            
            self?.registerView.activityIndicator.stopAnimating()
            self?.registerView.activityIndicator.isHidden = true
        }
        
//        registerView.reverificationButton.backgroundColor = UIColor.systemGray
//        reverificationButton?.isEnabled = false
//        registerView.textField.isEnabled = true
//        totalTimeInSeconds = 180
//        
//        registerView.activityIndicator.stopAnimating()
//        registerView.activityIndicator.isHidden = true
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:    #selector(updateTimer), userInfo: nil, repeats: true)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        
        registerView.textField.isEnabled = false
        registerView.nextButton.isEnabled = false
        registerView.nextButton.backgroundColor = UIColor.systemGray
    }

    @objc private func updateTimer() {
        if totalTimeInSeconds == 120 || totalTimeInSeconds == 60 || totalTimeInSeconds == 0 {
            registerView.reverificationButton.backgroundColor = UIColor.AccentButtonBackgroundColor
            reverificationButton?.isEnabled = true
            if totalTimeInSeconds == 0 {
                stopTimer()
                return
            }
        }

        if totalTimeInSeconds > 0 {
            totalTimeInSeconds -= 1
            updateTimerLabel()
        } else {
            stopTimer()
        }
    }

    private func updateTimerLabel() {
        let minutes = totalTimeInSeconds / 60
        let seconds = totalTimeInSeconds % 60
        registerView.timeLimitCountLabel.text = String(format: "%d:%02d", minutes, seconds)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)

        let allowedCharacters = CharacterSet(charactersIn: "0123456789")
        let characterSet = CharacterSet(charactersIn: string)

        if !allowedCharacters.isSuperset(of: characterSet) || prospectiveText.count > 6 {
            return false
        }
        
        if prospectiveText.count > 0 {
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
