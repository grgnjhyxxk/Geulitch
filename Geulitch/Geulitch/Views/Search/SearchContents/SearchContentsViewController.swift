//
//  SearchContentsViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 11/11/24.
//

import UIKit
import SnapKit
import SkeletonView
import SDWebImage

class SearchContentsViewController: UIViewController, UISearchBarDelegate {
    let searchContentsView = SearchContentsView()
    private var searchUsers: [UserData] = []  // 데이터를 저장할 변수
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.alpha = 0
        navigationController?.navigationBar.alpha = 0

        setupNavigation()
        setupView()
        
        searchContentsView.searchController.delegate = self
        
        searchContentsView.searchHistoryTableView.dataSource = self
        searchContentsView.searchHistoryTableView.delegate = self
        
        searchContentsView.searchedRseultTableView.dataSource = self
        searchContentsView.searchedRseultTableView.delegate = self
                
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.view.alpha = 1
            self.navigationController?.navigationBar.alpha = 1
            
            self.searchContentsView.searchController.searchTextField.snp.updateConstraints { make in
                make.leading.equalTo(75)
                make.trailing.equalTo(-15)
                make.height.equalTo(40)
                make.center.equalToSuperview()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.clear
        self.searchContentsView.searchController.becomeFirstResponder()
    }
    
    private func setupNavigation() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = UIColor.primaryBackgroundColor
        navigationBarAppearance.shadowColor = .clear
        navigationBarAppearance.shadowImage = UIImage()
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        navigationItem.titleView = searchContentsView.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.primaryBackgroundColor
        
        view.addSubview(searchContentsView)
                
        searchContentsView.searchController.searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(40)
            make.center.equalToSuperview()
        }
        
        searchContentsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.top.equalTo(self.view.safeAreaInsets.top) // or you can set the top to a custom value
        }
    }
        
    @objc func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count > 0 else {
            self.isLoading = false
            self.searchContentsView.searchedRseultTableView.isHidden = true
            self.searchContentsView.searchHistoryTableView.alpha = 1
            searchContentsView.searchHistoryTableView.reloadData()

            return
        }

        isLoading = true
        searchContentsView.searchedRseultTableView.reloadData()
        
        NetworkManager.shared.searchUsers(with: searchText) { [weak self] result in
            switch result {
            case .success(let users):
                self?.searchUsers = users
            case .failure(let error):
                print("검색 실패: \(error.localizedDescription)")
            }
        }
        
        UIView.animate(withDuration: 0.35, animations: {
            self.searchContentsView.searchedRseultTableView.isHidden = false
        })
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.isLoading = false
            self.searchContentsView.searchedRseultTableView.reloadData()
        }
    }
}

extension SearchContentsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView ==  searchContentsView.searchHistoryTableView {
            return 3
        } else if tableView ==  searchContentsView.searchedRseultTableView {
            if isLoading {
                return 7
            } else {
                return searchUsers.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchContentsView.searchedRseultTableView {
            if isLoading {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonTableViewCell.identifier, for: indexPath) as? SkeletonTableViewCell else {
                    return UITableViewCell()
                }
                
                cell.circleView.snp.updateConstraints { make in
                    make.top.equalTo(15)
                }
                                
                DispatchQueue.main.async {
                    let animationDuration: TimeInterval = 1.0
                    let animation = SkeletonAnimationBuilder()
                        .makeSlidingAnimation(withDirection: .leftRight, duration: animationDuration)
                    let gradient = SkeletonGradient(baseColor: UIColor.skeleton)
                    cell.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
                }
                                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchedResultTableCustomCell.identifier, for: indexPath) as? SearchedResultTableCustomCell else {
                    return UITableViewCell() }
                                               
                let user = searchUsers[indexPath.row]
                cell.userIDLabel.text = user.userID.value  // userID를 가져오는 부분
                cell.penNameLabel.text = user.penName.value  // penName을 가져오는 부분
                
                if let urlString = user.userProfileImage.value, let url = URL(string: urlString) {
                    // 비동기적으로 이미지 로드, 기본 이미지도 설정
                    cell.userProfileImageView.sd_setImage(with: url, placeholderImage: UIImage())
                } else {
                    // 이미지 URL이 없을 경우 기본 이미지 설정
                    cell.userProfileImageView.image = UIImage(named: "DefaultUserProfileImage")
                }
                
                return cell
            }
        } else if tableView == searchContentsView.searchHistoryTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryTableCustomCell.identifier, for: indexPath) as? SearchHistoryTableCustomCell else {
                return UITableViewCell() }
            
            if indexPath.row == 0 {
                cell.setupSearchUserConstraints()
            } else if indexPath.row == 1 {
                cell.setupSearchTextConstraints()
            } else if indexPath.row == 2 {
                cell.setupSearchTextConstraints()
            }
                                    
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == searchContentsView.searchHistoryTableView {
            return UITableView.automaticDimension
        } else if tableView == searchContentsView.searchedRseultTableView {
            return isLoading ? 89 : UITableView.automaticDimension
        }
        
        return UITableView.automaticDimension
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
