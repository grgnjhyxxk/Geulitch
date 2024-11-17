//
//  BasePostEditorViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/15/24.
//

import UIKit
import SnapKit
import Then
import RichTextKit

class BasePostEditorViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private lazy var closedButtonItem: UIBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: nil, action: nil).then {
        $0.tintColor = UIColor.SubLabelTextColor
    }
    
    private lazy var postingButtonItem: UIBarButtonItem = UIBarButtonItem(title: "게시", style: .done, target: nil, action: nil).then {
        $0.tintColor = UIColor.AccentButtonBackgroundColor
    }
    
    private let richTextKit = RichTextView().then {
        $0.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.font = UIFont.notoSans(size: 16, weight: .regular)
        $0.textColor = UIColor.primaryTextColor
        $0.backgroundColor = UIColor.clear
    }
    
    private let bottomView = UIView().then {
        $0.backgroundColor = UIColor.skeleton
        $0.layer.cornerRadius = 10
    }
    
    private let keyboardHideButton = UIButton().then {
        $0.setImage(UIImage(systemName: "keyboard.chevron.compact.down")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)), for: .normal)
        $0.tintColor = UIColor.AccentButtonBackgroundColor
    }
    
    private let insertImageButton = UIButton().then {
        $0.setImage(UIImage(systemName: "photo.on.rectangle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)), for: .normal)
        $0.tintColor = UIColor.AccentButtonBackgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        setupLayout()
        addTargets()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupNavigation() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor.primaryBackgroundColor
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.shadowImage = UIImage()
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        closedButtonItem.target = self
        closedButtonItem.action = #selector(closedButtonTapped)
        
        postingButtonItem.target = self
        postingButtonItem.action = #selector(postingButtonTapped)
        
        navigationItem.leftBarButtonItem = closedButtonItem
        navigationItem.rightBarButtonItem = postingButtonItem
        navigationItem.title = "글쓰기"
    }
    
    @objc private func closedButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func postingButtonTapped() {
        dismiss(animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.primaryBackgroundColor
        view.addSubview(richTextKit)
        view.addSubview(bottomView)
        
        bottomView.addSubview(keyboardHideButton)
        bottomView.addSubview(insertImageButton)

    }
    
    private var richTextKitBottomConstraint: Constraint?

    private func setupLayout() {
        richTextKit.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            richTextKitBottomConstraint = make.bottom.equalTo(bottomView.snp.top).constraint
        }
        
        bottomView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-40)
            make.width.equalToSuperview().offset(-30)
            make.height.equalTo(50)
        }
                
        keyboardHideButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-15)
        }
        
        insertImageButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(15)
        }
    }
    
    private func addTargets() {
        keyboardHideButton.addTarget(self, action: #selector(keyboardHideButtonTapped), for: .touchUpInside)
        insertImageButton.addTarget(self, action: #selector(insertImageButtonTapped), for: .touchUpInside)
    }
    
    @objc private func keyboardHideButtonTapped() {
        richTextKit.resignFirstResponder()
    }
    
    
    @objc private func insertImageButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height

            UIView.animate(withDuration: 0.3) {
                self.bottomView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight + 25)
                self.richTextKitBottomConstraint?.update(offset: -keyboardHeight + 25)
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.bottomView.transform = .identity
            self.richTextKitBottomConstraint?.update(offset: 0)
            self.view.layoutIfNeeded()
        }
    }
}
