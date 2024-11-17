//
//  AccountSettingView.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/25/24.
//
import UIKit
import SnapKit
import Then

class AccountSettingView: UIView {
    let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(AccountSettingTableCustomCell.self, forCellReuseIdentifier: AccountSettingTableCustomCell.identifier)
        $0.tableFooterView = UIView()
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    let profileImageView = UIImageView().then {
        $0.backgroundColor = UIColor.skeleton
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
        addSubview(tableView)
    }
    
    private func setupViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
