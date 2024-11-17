//
//  UserProfileViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 11/16/24.
//

import UIKit
import SnapKit
import Aquaman
import RxSwift
import RxCocoa

final class UserProfileViewController: ProfileViewController {
    var userObservable: Observable<UserData>
    var userManager: UserManagerProtocol
    var documentID: String?
    
    init(userObservable: Observable<UserData>, userManager: UserManagerProtocol, documentID: String?) {
        self.userObservable = userObservable
        self.userManager = userManager
        self.documentID = documentID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        let userData = UserData(
            documentID: "",
            userID: BehaviorRelay(value: ""),
            penName: BehaviorRelay(value: ""),
            introduction: BehaviorRelay(value: ""),
            userProfileImage: BehaviorRelay(value: ""),
            follower: BehaviorRelay(value: []),
            privacySetting: BehaviorRelay(value: false)
        )
        self.userObservable = Observable.just(userData)  // 기본값으로 초기화
        self.userManager = DefaultUserManager()  // userManager는 적절한 값으로 초기화
        self.documentID = "defaultDocumentID"
        super.init(coder: coder)
    }
    
    override var pages: [AquamanChildViewController] {
        return [
            ContentsViewController(with: .post),
            ContentsViewController(with: .series),
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateHeight()
        self.updateLayout()
        
        if profileView.privacySettingButton.tintColor == UIColor.AccentButtonBackgroundColor {
            profileView.userProfileImageButton.removeTarget(self, action: nil, for: .touchUpInside  )
        }
    }
    
    override func bindUserData() {
        self.profileView.bindUserData(userObservable: userObservable)
    }
    
    override func configureVisibility() {
        profileView.subscribeButton.isHidden = false
    }
    
    @objc override func refresh() {
        guard let documentID = documentID else {
            print("documentID is nil or invalid")
            return
        }
        print("documentID: \(documentID)")

        let currentIndex = self.currentIndex
        
        self.profileViewModel.fetchUser(documentID: documentID) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.userManager.updateUser(user)
                    // UserObservable의 값을 업데이트하여 UI가 반영되도록 함
                    self?.userObservable = Observable.just(user)  // userObservable 값 갱신
                }

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
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor.primaryBackgroundColor
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.shadowImage = UIImage()
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        let rightStackView = UIStackView.init(arrangedSubviews: [profileView.privacySettingButton, profileView.searchingPostButton, profileView.moreBarButton])
        rightStackView.spacing = 15
        
        let rightStackBarButtonItem = UIBarButtonItem(customView: rightStackView)
        
        profileView.privacySettingButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 34, height: 34))
        }
        
        profileView.searchingPostButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 34, height: 34))
        }
        
        profileView.moreBarButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 34, height: 34))
        }

        navigationItem.rightBarButtonItem = rightStackBarButtonItem
    }
    
    override func addTargets() { }
}
