//
//  MainFeedView.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/11/24.
//

import UIKit
import SnapKit
import Then
import BetterSegmentedControl

class MainFeedView: UIView {
    let segmentedControl: BetterSegmentedControl = {
        let segmentedControl = BetterSegmentedControl(
            frame: CGRect(x: 0, y: 0, width: 0, height: 0), segments: LabelSegment.segments(withTitles: ["추천", "구독"],
                                            normalFont: UIFont.notoSansKR(size: 14, weight: .bold),
                                                                                            normalTextColor: .primaryTextColor,
                                            selectedFont: UIFont.notoSansKR(size: 14, weight: .bold),
                                                                                            selectedTextColor: .AccentButtonTextColor),
            options: [.backgroundColor(UIColor.systemGray5.withAlphaComponent(1)),
                      .indicatorViewBackgroundColor(UIColor.SegmentControlIndicatorViewBackgroundColor),
                      .cornerRadius(17.5)]
        )
        
        return segmentedControl
    }()

    let recommendedTableRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = UIColor.primaryTextColor
        
        return refreshControl
    }()
    
    let subscribeRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = UIColor.primaryTextColor
        
        return refreshControl
    }()
    
    let recommendedTableView = UITableViewController().then {
        $0.tableView.backgroundColor = UIColor.clear
        $0.tableView.tableFooterView = UIView()
        $0.tableView.tableHeaderView = UIView()
        $0.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    let subscribeTableView = UITableViewController().then {
        $0.tableView.backgroundColor = UIColor.clear
        $0.tableView.tableFooterView = UIView()
        $0.tableView.tableHeaderView = UIView()
        $0.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil).then {
        $0.view.backgroundColor = UIColor.primaryBackgroundColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        recommendedTableView.tableView.register(RecommendedTableCustomCell.self, forCellReuseIdentifier: RecommendedTableCustomCell.identifier)
        subscribeTableView.tableView.register(RecommendedTableCustomCell.self, forCellReuseIdentifier: RecommendedTableCustomCell.identifier)
        
        recommendedTableView.tableView.register(SkeletonTableViewCell.self, forCellReuseIdentifier: SkeletonTableViewCell.identifier)
        subscribeTableView.tableView.register(SkeletonTableViewCell.self, forCellReuseIdentifier: SkeletonTableViewCell.identifier)
        
        recommendedTableView.tableView.refreshControl = recommendedTableRefreshControl
        subscribeTableView.tableView.refreshControl = subscribeRefreshControl
    }
    
    private func setupConstraints() {

    }
}
