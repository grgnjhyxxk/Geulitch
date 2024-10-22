//
//  TabBarController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/15/24.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        view.backgroundColor = UIColor.primaryBackgroundColor
        
        // 스크롤 안했을 때 배경색
        tabBar.barTintColor = UIColor.primaryBackgroundColor
        
        // 기본 배경색
        tabBar.backgroundColor = UIColor.primaryBackgroundColor
        
        // 아이콘 선택 시 색상
        tabBar.tintColor = UIColor.AccentButtonBackgroundColor
        
        // 아이콘 미선택 시 색상
        tabBar.unselectedItemTintColor = UIColor.gray
        
        // 투명도
        tabBar.isTranslucent = false
        
        tabBar.clipsToBounds = true
        
        tabBar.shadowImage = UIImage()
        
        tabBar.scrollEdgeAppearance?.backgroundColor = UIColor.primaryBackgroundColor
        tabBar.scrollEdgeAppearance?.backgroundColor = UIColor.primaryBackgroundColor
        
        let mainFeedViewController = UINavigationController(rootViewController: MainFeedViewController())
        let mainFeedViewIcon = UIImage(systemName: "house")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        let mainFeedViewSelectedIcon = UIImage(systemName: "house.fill")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        mainFeedViewController.tabBarItem = UITabBarItem(title: "",
                                                         image: mainFeedViewIcon,
                                                         selectedImage: mainFeedViewSelectedIcon)

        let searchingViewController = UIViewController()
        let searchingViewIcon = UIImage(systemName: "magnifyingglass")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        let searchingViewSelectedIcon = UIImage(systemName: "magnifyingglass")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        searchingViewController.tabBarItem = UITabBarItem(title: "",
                                                          image: searchingViewIcon,
                                                          selectedImage: searchingViewSelectedIcon)
        
        let imsiViewController = UIViewController()
        let imsiViewIcon = UIImage(systemName: "bell")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        let imsiViewSelectedIcon = UIImage(systemName: "bell.fill")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        imsiViewController.tabBarItem = UITabBarItem(title: "",
                                                     image: imsiViewIcon,
                                                     selectedImage: imsiViewSelectedIcon)
        
        let activityViewController = UIViewController()
        let activityViewIcon = UIImage(systemName: "heart")
        let activityViewSelectedIcon = UIImage(systemName: "heart.fill")
        activityViewController.tabBarItem = UITabBarItem(title: "",
                                                        image: activityViewIcon,
                                                        selectedImage: activityViewSelectedIcon)
        
        let myProfileViewController = UINavigationController(rootViewController: ProfileViewController())
        let myProfileViewIcon = UIImage(systemName: "person")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        let myProfileViewSelectedIcon = UIImage(systemName: "person.fill")?.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold))
        myProfileViewController.tabBarItem = UITabBarItem(title: "",
                                                          image: myProfileViewIcon,
                                                          selectedImage: myProfileViewSelectedIcon)
        
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
        
        viewControllers = [
                                mainFeedViewController,
                                searchingViewController,
                                imsiViewController,
                                activityViewController,
                                myProfileViewController
                          ]
    }
    
    @objc func buttonAction() {
        present(UIViewController(), animated: true)
    }
}
