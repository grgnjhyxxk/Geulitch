//
//  RecommendedUserView.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 11/10/24.
//

import UIKit
import SnapKit
import Then

class RecommendedUserView: UIView {
    let searchController = UISearchController().then {
        $0.searchBar.placeholder = "검색"
        $0.hidesNavigationBarDuringPresentation = false
        $0.searchBar.backgroundColor = UIColor.clear
        $0.searchBar.searchTextField.backgroundColor = UIColor.SearchViewTextFieldColor
        $0.searchBar.setValue("닫기", forKey: "cancelButtonText")
        $0.searchBar.tintColor = UIColor.primaryTextColor
        $0.searchBar.setShowsCancelButton(false, animated: false)
    }
    
    let recommendUserTableView = UITableView().then {
        $0.backgroundColor = UIColor.primaryBackgroundColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    let recommendUserTableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen().bounds.width, height: 42)).then {
        $0.backgroundColor = UIColor.primaryBackgroundColor
    }
    
    let recommedUserTitleLabel = UILabel().then {
        $0.text = "신규유저"
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 15, weight: .semibold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(recommendUserTableView)
        
        recommendUserTableHeaderView.addSubview(recommedUserTitleLabel)
        
        recommendUserTableView.register(RecommendUserTableCustomCell.self, forCellReuseIdentifier: RecommendUserTableCustomCell.identifier)
        recommendUserTableView.tableHeaderView = recommendUserTableHeaderView
    }
    
    private func setupViewConstraints() {
        recommendUserTableView.snp.makeConstraints { make in
            make.top.equalTo(75)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        recommedUserTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.equalTo(15)
        }
    }
}
