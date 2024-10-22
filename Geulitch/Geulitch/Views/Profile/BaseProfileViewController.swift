//
//  BaseProfileViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/15/24.
//

import UIKit
import Aquaman

final class ProfileViewController: AquamanPageViewController {
    private lazy var isPrivateAccountButtonItem = UIBarButtonItem(image: UIImage(systemName: "globe")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)), style: .done, target: .none, action: .none).then {
        $0.tintColor = UIColor.AccentButtonBackgroundColor
    }
    
    private lazy var accountSettingBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)), style: .done, target: nil, action: nil).then {
        $0.tintColor = UIColor.AccentButtonBackgroundColor
    }
    
    private lazy var profileView: ProfileView = {
        ProfileView()
    }()
    
    private lazy var computedProfileView: ProfileView = {
        ProfileView()
    }()
    
    private lazy var categoryView: CategoryView = {
        CategoryView()
    }()
    
    private var isCompleteLayout = false
    
    private var headerViewHeight: CGFloat = 0.0
    
    private var lastContentOffset: CGFloat = 0

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc private func refresh() {
        pages.forEach {
            let viewController = $0 as? ContentsViewController
            
            viewController?.isLoading = true
            viewController?.reload()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                viewController?.isLoading = false
                viewController?.reload()
                self.refreshControl.endRefreshing()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigation()
        
        view.backgroundColor = UIColor.primaryBackgroundColor
        mainScrollView.backgroundColor = UIColor.primaryBackgroundColor
        
        bindEvents()
        
        view.addSubview(computedProfileView)
        computedProfileView.isHidden = true
        
        computedProfileView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        mainScrollView.delegate = self
    }
    
    private func setupNavigation() {
        let backBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor.primaryTextColor
        navigationItem.backBarButtonItem = backBarButtonItem
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor.primaryBackgroundColor
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.shadowImage = UIImage()
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance

        accountSettingBarButtonItem.target = self
        accountSettingBarButtonItem.action = #selector(accountSettingButtonTapped)

        navigationItem.leftBarButtonItem = isPrivateAccountButtonItem
        navigationItem.rightBarButtonItem = accountSettingBarButtonItem
    }
    
    @objc private func accountSettingButtonTapped() {
        let accountSettingVC = AccountSettingViewController()
        navigationController?.pushViewController(accountSettingVC, animated: true)
    }

    private let pages: [AquamanChildViewController] = [
        ContentsViewController(with: .post),
        ContentsViewController(with: .series),
    ]
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let blurbSize = profileView.postBlurbTextView.sizeThatFits(CGSize(width: view.frame.width, height: CGFloat.greatestFiniteMagnitude))
        
        profileView.postBlurbTextView.snp.updateConstraints { make in
            make.height.equalTo(blurbSize.height) // 유동적으로 높이 설정
        }
        
        headerViewHeight = 15 + 54 + blurbSize.height + 16 + 35 + 15
        
        if isCompleteLayout == false, headerViewHeight > 0 {
            reloadData()
            isCompleteLayout = true
        }
        
        mainScrollView.refreshControl = refreshControl
    }
    
    private func bindEvents() {
        categoryView.changeCategoryAction = { [weak self] category in
            switch category {
            case .post:
                self?.setSelect(index: 0, animation: true)
            case .series:
                self?.setSelect(index: 1, animation: true)
            }
        }
    }
    
    override func headerViewFor(_ pageController: AquamanPageViewController) -> UIView {
        profileView
    }
    
    override func headerViewHeightFor(_ pageController: AquamanPageViewController) -> CGFloat {
        headerViewHeight
    }
    
    override func numberOfViewControllers(in pageController: AquamanPageViewController) -> Int {
        pages.count
    }
    
    override func menuViewFor(_ pageController: AquamanPageViewController) -> UIView {
        categoryView
    }
    
    override func menuViewHeightFor(_ pageController: AquamanPageViewController) -> CGFloat {
        40.0
    }
    
    override func pageController(_ pageController: AquamanPageViewController, contentScrollViewDidEndScroll scrollView: UIScrollView) {
        switch currentIndex {
        case 0:
            categoryView.selectedCategory = .post
        case 1:
            categoryView.selectedCategory = .series
        default:
            return
        }
    }
    
    override func pageController(
        _ pageController: AquamanPageViewController,
        viewControllerAt index: Int
    ) -> (any UIViewController & AquamanChildViewController) {
        pages[index]
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
        
        lastContentOffset = offsetY
    }
}
