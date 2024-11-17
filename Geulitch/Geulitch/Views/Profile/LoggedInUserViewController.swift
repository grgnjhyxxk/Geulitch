//
//  LoggedInUserViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 11/16/24.
//

import UIKit
import Aquaman

final class LoggedInUserViewController: ProfileViewController {
    override var pages: [AquamanChildViewController] {
        return [
            ContentsViewController(with: .post),
            ContentsViewController(with: .series),
        ]
    }
    
    private let useCustomNavigation: Bool
    
    init(useCustomNavigation: Bool) {
        self.useCustomNavigation = useCustomNavigation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bindUserData() {
        let selectedUser = LoggedInUserManager.shared.loggedInUser
        let nonOptionalUser = selectedUser.compactMap { $0 }
        self.profileView.bindUserData(userObservable: nonOptionalUser)
    }
    
    override func configureVisibility() {
        profileView.profileEditButton.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateHeight()
        self.updateLayout()
    }
    
    @objc override func refresh() {
        let currentIndex = self.currentIndex
        
        self.profileViewModel.fetchLoggedInUser { [weak self] result in
            switch result {
            case .success(let user):
                LoggedInUserManager.shared.setLoggedInUser(user)
                print("User fetched successfully: \(user)")

                if let viewController = self?.pages[currentIndex] as? ContentsViewController {
                    self?.refreshControl.endRefreshing()
                    viewController.reload()
                    self?.updateHeight()
                    self?.updateLayout()
                }
            case .failure(let error):
                print("Failed to fetch user: \(error.localizedDescription)")
            }
        }
    }
    
    override func setupNavigation() {
        let backBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor.primaryTextColor
        navigationItem.backBarButtonItem = backBarButtonItem
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor.primaryBackgroundColor
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.shadowImage = UIImage()
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        let rightStackView = UIStackView(arrangedSubviews: [profileView.searchingPostButton])

        profileView.searchingPostButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 34, height: 34))
        }
        
        if useCustomNavigation {
            let leftStackView = UIStackView(arrangedSubviews: [profileView.privacySettingButton])
            let leftStackBarButtonItem = UIBarButtonItem(customView: leftStackView)
            
            rightStackView.addArrangedSubview(profileView.accountSettingBarButton)
            rightStackView.spacing = 15
            let rightStackBarButtonItem = UIBarButtonItem(customView: rightStackView)
            
            profileView.accountSettingBarButton.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 34, height: 34))
            }
            
            profileView.privacySettingButton.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 34, height: 34))
            }
            
            navigationItem.leftBarButtonItem = leftStackBarButtonItem
            navigationItem.rightBarButtonItem = rightStackBarButtonItem
        } else {
            let rightStackView = UIStackView(arrangedSubviews: [profileView.searchingPostButton])
            let rightStackBarButtonItem = UIBarButtonItem(customView: rightStackView)
            
            navigationItem.rightBarButtonItem = rightStackBarButtonItem
        }
    }
    
    override func addTargets() {
        profileView.accountSettingBarButton.addTarget(self, action: #selector(accountSettingButtonTapped), for: .touchUpInside)
        profileView.profileEditButton.addTarget(self, action: #selector(profileEditButtonTapped), for: .touchUpInside)
    }
    
    @objc private func accountSettingButtonTapped() {
        let accountSettingVC = AccountSettingViewController()
        navigationController?.pushViewController(accountSettingVC, animated: true)
    }
    
    @objc private func profileEditButtonTapped() {
        let profileInfoEditVC = UINavigationController(rootViewController: ProfileInfoEditViewController())
        profileInfoEditVC.modalPresentationStyle = .fullScreen
        present(profileInfoEditVC, animated: true)
    }
    
    override func pageController(_ pageController: AquamanPageViewController, mainScrollViewDidScroll scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY <= 0 {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }
        } else if offsetY > 0 {
            UIView.animate(withDuration: 0.3) {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }
        }
    }
}
