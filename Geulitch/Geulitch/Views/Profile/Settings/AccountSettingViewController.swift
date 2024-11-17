//
//  AccountSettingViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/20/24.
//

//
//  AccountSettingViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/20/24.
//

import UIKit
import SnapKit
import Then

class AccountSettingViewController: UIViewController {
    private let accountSettingView: AccountSettingView = AccountSettingView()
    
    private let settingItems: [(String, String?)] = [
        ("친구 팔로우 및 초대", "person.badge.plus"),
        ("알림", "bell"),
        ("저장됨", "bookmark"),
        ("좋아요", "heart"),
        ("개인정보 보호", "lock"),
        ("계정", "person"),
        ("도움말", "questionmark.circle"),
        ("정보", "info.circle"),
        ("로그아웃", nil)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
    }
    
    private func setupNavigation() {
        navigationItem.title = "설정"
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.primaryBackgroundColor

        view.addSubview(accountSettingView)
        
        accountSettingView.tableView.delegate = self
        accountSettingView.tableView.dataSource = self
        
        accountSettingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "계정에서 로그아웃하시겠습니까?", message: "", preferredStyle: .alert)
        
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.primaryBackgroundColor
        
        let deleteAction = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            self.clearUserSession()
            
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                return
            }
            
            let authenticationViewController = AuthenticationViewController()
            let navigationController = UINavigationController(rootViewController: authenticationViewController)
            
            // 애니메이션 적용
            UIView.transition(with: sceneDelegate.window!, duration: 0.2, options: .transitionCrossDissolve, animations: {
                sceneDelegate.window?.rootViewController = navigationController
            }, completion: { _ in
                sceneDelegate.window?.makeKeyAndVisible()
            })
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.primaryTextColor, forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func clearUserSession() {
        UserDefaults.standard.removeObject(forKey: "autoLoginDocumentID")
        UserDefaults.standard.removeObject(forKey: "autoLoginPassword")
        LoggedInUserManager.shared.clearLoggedInUser()
    }
}

extension AccountSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSettingTableCustomCell.identifier, for: indexPath) as? AccountSettingTableCustomCell else {
            return UITableViewCell()
        }
        
        let (title, iconName) = settingItems[indexPath.row]
        
        cell.configure(with: title, iconName: iconName)

        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row != 7 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == settingItems.count - 1 {
            print("logout")
            showAlert()
        }
    }
}
