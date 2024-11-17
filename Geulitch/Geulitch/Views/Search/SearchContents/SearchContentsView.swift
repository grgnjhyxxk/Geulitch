//
//  SearchContentsView.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 11/11/24.
//

import UIKit
import SnapKit
import Then

class SearchContentsView: UIView {
    let searchController = UISearchBar().then {
        $0.placeholder = "검색"
//        $0.hidesNavigationBarDuringPresentation = false
        $0.backgroundColor = UIColor.clear
        $0.searchTextField.backgroundColor = UIColor.SearchViewTextFieldColor
        $0.setValue("닫기", forKey: "cancelButtonText")
        $0.tintColor = UIColor.primaryTextColor
        $0.setShowsCancelButton(false, animated: false)
    }
    
    let searchHistoryTableView = UITableView().then {
        $0.backgroundColor = UIColor.primaryBackgroundColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.alpha = 1
    }
    
    let searchHistoryTableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen().bounds.width, height: 42)).then {
        $0.backgroundColor = UIColor.clear
    }
    
    let searchHistoryTitleLabel = UILabel().then {
        $0.text = "최근검색"
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 15, weight: .semibold)
    }
    
    let searchHistoryClearButton = UIButton().then {
        $0.setTitle("전체삭제", for: .normal)
        $0.setTitleColor(UIColor.SubButtonTextColor, for: .normal)
        $0.titleLabel?.font = UIFont.notoSansKR(size: 14, weight: .regular)
    }
    
    let searchedRseultTableView = UITableView().then {
        $0.backgroundColor = UIColor.primaryBackgroundColor
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.isHidden = true
    }
    
    let searchedRseultTableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen().bounds.width, height: 42)).then {
        $0.backgroundColor = UIColor.clear
    }
    
    let searchedRseultTitleLabel = UILabel().then {
        $0.text = "검색결과"
        $0.textColor = UIColor.primaryTextColor
        $0.font = UIFont.notoSansKR(size: 15, weight: .semibold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchHistoryTableView()
        setupSearchedRseultTableView()
        setupViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSearchHistoryTableView() {
        addSubview(searchHistoryTableView)
        
        searchHistoryTableHeaderView.addSubview(searchHistoryTitleLabel)
        searchHistoryTableHeaderView.addSubview(searchHistoryClearButton)
        
        searchHistoryTableView.register(SearchHistoryTableCustomCell.self, forCellReuseIdentifier: SearchHistoryTableCustomCell.identifier)
        searchHistoryTableView.tableHeaderView = searchHistoryTableHeaderView
    }
    
    private func setupSearchedRseultTableView() {
        addSubview(searchedRseultTableView)
        
        searchedRseultTableHeaderView.addSubview(searchedRseultTitleLabel)
        
        searchedRseultTableView.register(SearchedResultTableCustomCell.self, forCellReuseIdentifier: SearchedResultTableCustomCell.identifier)
        searchedRseultTableView.register(SkeletonTableViewCell.self, forCellReuseIdentifier: SkeletonTableViewCell.identifier)

        searchedRseultTableView.tableHeaderView = searchedRseultTableHeaderView
    }
    
    private func setupViewConstraints() {
        searchHistoryTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        searchHistoryTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.equalTo(15)
        }
        
        searchHistoryClearButton.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.trailing.equalTo(-15)
        }
        
        searchedRseultTableView.snp.makeConstraints { make in
            make.top.equalTo(75)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        searchedRseultTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.equalTo(15)
        }
    }
}
