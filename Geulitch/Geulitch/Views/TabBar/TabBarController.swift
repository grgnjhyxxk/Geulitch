//
//  TabBarController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/15/24.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        delegate = self // UITabBarControllerDelegate 설정
    }

    private func setupTabBar() {
        view.backgroundColor = UIColor.primaryBackgroundColor
        tabBar.barTintColor = UIColor.primaryBackgroundColor
        tabBar.backgroundColor = UIColor.primaryBackgroundColor
        tabBar.tintColor = UIColor.AccentButtonBackgroundColor
        tabBar.unselectedItemTintColor = UIColor.systemGray
        tabBar.isTranslucent = false
        tabBar.clipsToBounds = true
        tabBar.shadowImage = UIImage()
        tabBar.scrollEdgeAppearance?.backgroundColor = UIColor.primaryBackgroundColor

        let mainFeedViewController = UINavigationController(rootViewController: MainFeedViewController())
        mainFeedViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "house")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)),
            selectedImage: UIImage(systemName: "house.fill")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        )

        let searchingViewController = UINavigationController(rootViewController: RecommendedUserViewController())
        searchingViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "magnifyingglass")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)),
            selectedImage: UIImage(systemName: "magnifyingglass")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        )

        let imsiViewController = UIViewController()
        imsiViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "bell")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)),
            selectedImage: UIImage(systemName: "bell.fill")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        )

        let activityViewController = MainFeedViewController()
        activityViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )

        let myProfileViewController = UINavigationController(rootViewController: LoggedInUserViewController(useCustomNavigation: true))
        myProfileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "person")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)),
            selectedImage: UIImage(systemName: "person.fill")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        )

        viewControllers = [
            mainFeedViewController,
            searchingViewController,
            imsiViewController,
            activityViewController,
            myProfileViewController
        ]

        addCenterButton() // 가운데 버튼 추가
    }

    private func addCenterButton() {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)), for: .normal)
        button.tintColor = UIColor.AccentButtonTextColor
        button.backgroundColor = UIColor.AccentButtonBackgroundColor
        button.layer.cornerRadius = 10
        view.addSubview(button)

        button.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-45)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 50, height: 35))
        }

        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }

    @objc func buttonAction() {
        let BasePostEditorVC = UINavigationController(rootViewController: BasePostEditorViewController())
        BasePostEditorVC.modalPresentationStyle = .fullScreen
        present(BasePostEditorVC, animated: true)
    }

    // UITabBarControllerDelegate 메서드 구현
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let viewControllers = viewControllers else { return false }

        // 클릭된 뷰 컨트롤러의 인덱스가 가운데(예: 세 번째) 뷰 컨트롤러인지 확인
        let middleIndex = viewControllers.count / 2
        if let index = viewControllers.firstIndex(of: viewController), index == middleIndex {
            // 가운데 탭이 선택될 때 버튼 동작으로 분기
            buttonAction()
            return false // 탭 선택 방지
        }
        return true
    }
}
