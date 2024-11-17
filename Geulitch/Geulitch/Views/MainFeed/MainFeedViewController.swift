//
//  MainFeedViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/11/24.
//

import UIKit
import SnapKit
import BetterSegmentedControl
import SkeletonView

class MainFeedViewController: UIViewController {
    private let mainFeedView: MainFeedView = MainFeedView()
    private var viewControllers: [UIViewController] = []
    private var isLoading = true

    private lazy var segmentedControl: BetterSegmentedControl = {
        let segmentedControl = BetterSegmentedControl(
            frame: CGRect(x: 0, y: 0, width: 0, height: 0), segments: LabelSegment.segments(withTitles: ["추천", "구독"],
                                            normalFont: UIFont.notoSansKR(size: 14, weight: .bold),
                                                                                            normalTextColor: .primaryTextColor,
                                            selectedFont: UIFont.notoSansKR(size: 14, weight: .bold),
                                                                                            selectedTextColor: .AccentButtonTextColor),
            options: [.backgroundColor(UIColor.skeleton),
                      .indicatorViewBackgroundColor(UIColor.SegmentControlIndicatorViewBackgroundColor),
                      .cornerRadius(17.5)]
        )
        
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        return segmentedControl
    }()
    
    private lazy var recommendedTableRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = UIColor.primaryTextColor
        refreshControl.addTarget(self, action: #selector(refreshRecommendedTable), for: .valueChanged)

        return refreshControl
    }()
    
    private lazy var subscribeRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = UIColor.primaryTextColor
        refreshControl.addTarget(self, action: #selector(refreshsubscribeTable), for: .valueChanged)

        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        setupPageViewController()
        
        mainFeedView.recommendedTableView.tableView.delegate = self
        mainFeedView.recommendedTableView.tableView.dataSource = self
        mainFeedView.subscribeTableView.tableView.delegate = self
        mainFeedView.subscribeTableView.tableView.dataSource = self
        
        mainFeedView.pageViewController.dataSource = self
        mainFeedView.pageViewController.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            self.mainFeedView.recommendedTableView.tableView.reloadData()
            self.mainFeedView.subscribeTableView.tableView.reloadData()
        }
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.titleView = segmentedControl
    }
    
    private func setupView() {        
        view.backgroundColor = UIColor.primaryBackgroundColor
        view.addSubview(mainFeedView)

        segmentedControl.snp.makeConstraints { make in
            make.width.equalTo(130)
            make.height.equalTo(35)
        }
            
        mainFeedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainFeedView.recommendedTableView.tableView.refreshControl = recommendedTableRefreshControl
        mainFeedView.subscribeTableView.tableView.refreshControl = subscribeRefreshControl
    }
    
    private func setupPageViewController() {
        viewControllers = [mainFeedView.recommendedTableView, mainFeedView.subscribeTableView]
        
        if let firstVC = viewControllers.first {
            mainFeedView.pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        addChild(mainFeedView.pageViewController)
        view.addSubview(mainFeedView.pageViewController.view)
        
        mainFeedView.pageViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainFeedView.pageViewController.didMove(toParent: self)
    }
    
    @objc private func refreshRecommendedTable(sebder: UIRefreshControl) {
        isLoading = true
        mainFeedView.recommendedTableView.tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isLoading = false
            self.mainFeedView.recommendedTableView.tableView.reloadData()
            
            sebder.endRefreshing()
        }
    }
    
    @objc private func refreshsubscribeTable(sebder: UIRefreshControl) {
        isLoading = true
        mainFeedView.subscribeTableView.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isLoading = false
            self.mainFeedView.subscribeTableView.tableView.reloadData()
            
            sebder.endRefreshing()
        }
    }
    
    @objc private func segmentChanged(sender: BetterSegmentedControl) {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        impactFeedbackGenerator.impactOccurred()

        let selectedIndex = sender.index
        print("선택된 인덱스: \(selectedIndex)")
        
        let direction: UIPageViewController.NavigationDirection = selectedIndex == 0 ? .reverse : .forward
        
        mainFeedView.pageViewController.setViewControllers([viewControllers[selectedIndex]], direction: direction, animated: true, completion: nil)
    }
}

extension MainFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
             return 6 
         }
        
        if tableView == mainFeedView.recommendedTableView.tableView {
            return 10
        } else if tableView == mainFeedView.subscribeTableView.tableView {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonTableViewCell.identifier, for: indexPath) as? SkeletonTableViewCell else {
             return UITableViewCell()
            }
            
            DispatchQueue.main.async {
                let animationDuration: TimeInterval = 1.0
                let animation = SkeletonAnimationBuilder()
                    .makeSlidingAnimation(withDirection: .leftRight, duration: animationDuration)
                let gradient = SkeletonGradient(baseColor: UIColor.skeleton)
                cell.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
            }
            
            return cell
         }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableCustomCell.identifier, for: indexPath) as? FeedTableCustomCell else {
            return UITableViewCell() }
        if indexPath.row == 0 {
            cell.postBlurbTextLabel.text = "Test"
        } else {
            cell.postBlurbTextLabel.text = "Test"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isLoading ? 120 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)번 셀 클릭")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLoading {
            cell.separatorInset = UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)
            tableView.allowsSelection = false
        } else {
            cell.separatorInset = .zero
            tableView.allowsSelection = true
        }
        
        cell.selectionStyle = .none
    }
}

extension MainFeedViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController), index < viewControllers.count - 1 else {
            return nil
        }
        return viewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let visibleVC = pageViewController.viewControllers?.first, let index = viewControllers.firstIndex(of: visibleVC) {
            segmentedControl.setIndex(index, animated: true)
        }
    }
}
