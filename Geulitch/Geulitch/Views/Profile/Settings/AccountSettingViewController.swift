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

class AccountSettingCell: UITableViewCell {
    static let identifier = "AccountSettingCell"
    
    private let iconImageView = UIImageView().then {
        $0.tintColor = UIColor.primaryTextColor
    }
    
    private let titleLabel = UILabel().then {
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 16, weight: .regular)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)

        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with title: String, iconName: String?) {
        titleLabel.text = title
        
        if let iconName = iconName {
            iconImageView.isHidden = false
            iconImageView.image = UIImage(systemName: iconName)
            
            titleLabel.snp.updateConstraints { make in
                make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            }
        } else {
            iconImageView.isHidden = true
            
            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(16)
            }
            
            titleLabel.textColor = UIColor.systemRed
            titleLabel.font = UIFont.notoSansKR(size: 16, weight: .semibold)
        }
    }
}

class AccountSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(AccountSettingCell.self, forCellReuseIdentifier: AccountSettingCell.identifier)
        $0.tableFooterView = UIView()
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
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
        setupTableView()
        view.backgroundColor = UIColor.primaryBackgroundColor
        navigationItem.title = "설정"
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "계정에서 로그아웃하시겠습니까?", message: "", preferredStyle: .alert)
        
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.primaryBackgroundColor
        
        let deleteAction = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            // 로그아웃 로직 실행 (예: 사용자 세션 정리, 토큰 삭제 등)
            self.clearUserSession() // 사용자 세션 초기화
            
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
        cancelAction.setValue(UIColor.white, forKey: "titleTextColor")
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func clearUserSession() {
        // 여기서 사용자 세션과 관련된 모든 정보를 초기화하는 코드를 작성합니다.
        // 예를 들어 UserDefaults를 사용하는 경우:
        UserDefaults.standard.removeObject(forKey: "autoLoginPhoneNumber")
        UserDefaults.standard.removeObject(forKey: "autoLoginPassword")
        // 필요에 따라 추가적인 세션 초기화 작업을 수행합니다.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AccountSettingCell.identifier, for: indexPath) as? AccountSettingCell else {
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
