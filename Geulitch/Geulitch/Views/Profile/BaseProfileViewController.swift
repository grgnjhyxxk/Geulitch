//
//  BaseProfileViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/15/24.
//

import UIKit
import Aquaman
import RxSwift
import RxCocoa
import Then

class ProfileViewController: AquamanPageViewController {
    lazy var profileView: ProfileView = {
        ProfileView()
    }()
    
    lazy var computedProfileView: ProfileView = {
        ProfileView()
    }()
    
    lazy var categoryView: CategoryView = {
        CategoryView()
    }()
    
    lazy var profileViewModel: ProfileViewModel = {
        ProfileViewModel()
    }()
    
    var isCompleteLayout = false
    
    var headerViewHeight: CGFloat = 0.0
        
    var pages: [AquamanChildViewController] {
        return []
    }
    
    func bindUserData() { }
    func setupNavigation() { }
    func addTargets() { }
    func configureVisibility() { }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = UIColor.primaryTextColor
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return refreshControl
    }()
    
    @objc func refresh() { }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        configureVisibility()
        bindUserData()
        bindEvents()
        addTargets()
        mainScrollView.delegate = self
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let color = UIColor.ButtonBorderColor
        let resolvedColor = color.resolvedColor(with: traitCollection)
        profileView.userProfileImageButton.layer.borderColor = resolvedColor.cgColor
        profileView.userProfileImageButton.layer.borderWidth = 0.25
        
        profileView.profileEditButton.layer.borderColor = resolvedColor.cgColor
        profileView.profileEditButton.layer.borderWidth = 1.0
    }

    private func setupView() {
        view.backgroundColor = UIColor.primaryBackgroundColor
        mainScrollView.backgroundColor = UIColor.primaryBackgroundColor
        
        view.addSubview(computedProfileView)
        
        computedProfileView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        computedProfileView.isHidden = true

        if let window = UIApplication.shared.windows.first {
            window.addSubview(profileView.blurView)
            window.addSubview(profileView.blurViewCancelFullButton)
            window.addSubview(profileView.blurViewCancelButton)
            window.addSubview(profileView.userProfileImageView)
            
            profileView.blurView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            profileView.blurViewCancelFullButton.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            profileView.blurViewCancelButton.snp.makeConstraints { make in
                make.top.equalTo(60)
                make.leading.equalTo(15)
                make.size.equalTo(CGSize(width: 34, height: 34))
            }
            
            profileView.userProfileImageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: 250, height: 250))
            }
            
            profileView.userProfileImageButton.addTarget(self, action: #selector(userProfileImageButtonTapped), for: .touchUpInside)
            profileView.blurViewCancelButton.addTarget(self, action: #selector(blurViewCancelAction), for: .touchUpInside)
            profileView.blurViewCancelFullButton.addTarget(self, action: #selector(blurViewCancelAction), for: .touchUpInside)

            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
            profileView.userProfileImageView.addGestureRecognizer(pinchGesture)
        }
    }
    
    @objc private func userProfileImageButtonTapped() {
        UIView.animate(withDuration: 0.15, animations: {
            self.profileView.blurView.alpha = 1
            self.profileView.blurViewCancelFullButton.alpha = 1
            self.profileView.blurViewCancelButton.alpha = 1
            self.profileView.userProfileImageView.alpha = 1

            self.view.layoutIfNeeded()
        })
    }
    
    @objc func blurViewCancelAction() {
        UIView.animate(withDuration: 0.15, animations: {
            self.profileView.blurView.alpha = 0
            self.profileView.blurViewCancelFullButton.alpha = 0
            self.profileView.blurViewCancelButton.alpha = 0
            self.profileView.userProfileImageView.alpha = 0

            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        
        if gesture.state == .changed || gesture.state == .began {
            gestureView.transform = gestureView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1.0
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.2, animations: {
                gestureView.transform = .identity // 초기 상태로 복구
            })
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        updateHeight()
        
        if isCompleteLayout == false, headerViewHeight > 0 {
            reloadData()
            isCompleteLayout = true
        }
        
        mainScrollView.refreshControl = refreshControl
    }
    
    func updateHeight() {
        if profileView.introductionTextView.text == "" {
            profileView.introductionTextView.snp.updateConstraints { make in
                make.height.equalTo(15)
            }
            headerViewHeight = 15 + 70 + 15 + 16 + 20 + 35
        } else {
            let blurbSize = profileView.introductionTextView.sizeThatFits(CGSize(width: view.frame.width, height: CGFloat.greatestFiniteMagnitude))
            
            profileView.introductionTextView.snp.updateConstraints { make in
                make.height.equalTo(blurbSize.height)
            }
            
            headerViewHeight = 15 + 70 + blurbSize.height  + 16 + 20 + 35
        }
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
        refreshControl.endRefreshing()
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
}
