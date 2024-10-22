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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupPageViewController()
        addTargets()
        
        mainFeedView.recommendedTableView.tableView.delegate = self
        mainFeedView.recommendedTableView.tableView.dataSource = self
        mainFeedView.subscribeTableView.tableView.delegate = self
        mainFeedView.subscribeTableView.tableView.dataSource = self
        
        mainFeedView.pageViewController.dataSource = self
        mainFeedView.pageViewController.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.mainFeedView.recommendedTableView.tableView.reloadData()
            self.mainFeedView.subscribeTableView.tableView.reloadData()
        }
    }
    
    private func setupView() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.titleView = mainFeedView.segmentedControl
        
        mainFeedView.segmentedControl.snp.makeConstraints { make in
            make.width.equalTo(130)
            make.height.equalTo(35)
        }
        
        view.backgroundColor = UIColor.primaryBackgroundColor
        view.addSubview(mainFeedView)
        
        mainFeedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
    
    private func addTargets() {
        mainFeedView.segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        mainFeedView.recommendedTableRefreshControl.addTarget(self, action: #selector(refreshRecommendedTable), for: .valueChanged)
        mainFeedView.subscribeRefreshControl.addTarget(self, action: #selector(refreshsubscribeTable), for: .valueChanged)
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
             return 5
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendedTableCustomCell.identifier, for: indexPath) as? RecommendedTableCustomCell else {
            return UITableViewCell() }
    
        cell.postTitleTextLabel.text = "시간의 작은 고요함 속에시간의 작은 고요함 속에시간의 작은 고요함 속에"
        cell.postBlurbTextLabel.text = "나는 그때, 그 나무의 고요함 속에서 오래전 죽은 자들이 사라져 가는 소리를 들었다. 나는 그때, 그 나무의 고요함 속에서 오래전 죽은 자들이 사라져 가는 소리를 들었다.나는 그때, 그 나무의 고요함 속에서 오래전 죽은 자들이 사라져 가는 소리를 들었다. 나는 그때, 그 나무의 고요함 속에서 오래전 죽은 자들이 사라져 가는 소리를 들었다."
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return isLoading ? 188 : 188
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLoading {
            cell.separatorInset = UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)
        } else {
            cell.separatorInset = .zero
        }
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
            mainFeedView.segmentedControl.setIndex(index, animated: true)
        }
    }
}
