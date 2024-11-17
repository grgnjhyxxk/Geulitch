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
        recommendedTableView.tableView.register(FeedTableCustomCell.self, forCellReuseIdentifier: FeedTableCustomCell.identifier)
        subscribeTableView.tableView.register(FeedTableCustomCell.self, forCellReuseIdentifier: FeedTableCustomCell.identifier)
        
        recommendedTableView.tableView.register(SkeletonTableViewCell.self, forCellReuseIdentifier: SkeletonTableViewCell.identifier)
        subscribeTableView.tableView.register(SkeletonTableViewCell.self, forCellReuseIdentifier: SkeletonTableViewCell.identifier)
    }
    
    private func setupConstraints() {

    }
}
