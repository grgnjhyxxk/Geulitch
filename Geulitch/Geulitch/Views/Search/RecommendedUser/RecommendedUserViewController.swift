//
//  RecommendedUserViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 11/10/24.
//

import UIKit
import SnapKit
import RxSwift
import SDWebImage

class RecommendedUserViewController: UIViewController, UISearchBarDelegate {
    private let recommendedUserView = RecommendedUserView()
    private let recommendedUserViewModel = RecommendedUserViewModel()
    private var recommendedUsers: [UserData] = []  // 데이터를 저장할 변수
    private let disposeBag = DisposeBag()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.tintColor = UIColor.primaryTextColor
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)

        return refreshControl
    }()
    
    @objc private func refresh(sebder: UIRefreshControl) {
        recommendedUserViewModel.fetchRecommendedUsers { [weak self] result in
            switch result {
            case .success(let users):
                print("추천 사용자 목록: \(users)")
                RecommendedUsersManager.shared.setRecommendedUsers(users)
                sebder.endRefreshing()
            case .failure(let error):
                print("추천 사용자 목록을 가져오는 데 실패했습니다: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        
        recommendedUserView.searchController.searchBar.delegate = self
        
        recommendedUserView.recommendUserTableView.dataSource = self
        recommendedUserView.recommendUserTableView.delegate = self
        
        recommendedUserView.alpha = 0
        
        RecommendedUsersManager.shared.recommendedUsers
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] users in
                print("추천 사용자 목록: \(users)")
                self?.recommendedUsers = users
                self?.recommendedUserView.recommendUserTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        recommendedUserViewModel.fetchRecommendedUsers { [weak self] result in
            switch result {
            case .success(let users):
                print("추천 사용자 목록: \(users)")
                RecommendedUsersManager.shared.setRecommendedUsers(users)
                UIView.animate(withDuration: 0.28, animations: {
                    self?.recommendedUserView.alpha = 1
                })
            case .failure(let error):
                print("추천 사용자 목록을 가져오는 데 실패했습니다: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = UIColor.clear
        
        let backBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor.primaryTextColor
        navigationItem.backBarButtonItem = backBarButtonItem
        navigationItem.titleView = recommendedUserView.searchController.searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.primaryBackgroundColor
        
        view.addSubview(recommendedUserView)
        
        recommendedUserView.recommendUserTableView.refreshControl = refreshControl
        
        recommendedUserView.searchController.searchBar.searchTextField.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(40)
            make.center.equalToSuperview()
        }
        
        recommendedUserView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let vc = SearchContentsViewController()
        self.navigationController?.pushViewController(vc, animated: false)
        return false
    }
}

extension RecommendedUserViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return recommendedUsers.count  // 구독된 데이터 사용
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendUserTableCustomCell.identifier, for: indexPath) as? RecommendUserTableCustomCell else {
           return UITableViewCell()
       }
       
       cell.selectionStyle = .none
       
       // 구독된 데이터를 사용하여 UI 업데이트
       let user = recommendedUsers[indexPath.row]
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
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if recommendedUsers[indexPath.row].documentID == LoggedInUserManager.shared.getDocumentID() {
           let loggedUserVC = LoggedInUserViewController(useCustomNavigation: false)
           navigationController?.pushViewController(loggedUserVC, animated: true)
       } else {
           let selectedUser = RecommendedUsersManager.shared.recommendedUsers
           let nonOptionalUser = selectedUser.compactMap { $0[indexPath.row] }
           let userProfileVC = UserProfileViewController(userObservable: nonOptionalUser, userManager: RecommendedUsersManager.shared, documentID: recommendedUsers[indexPath.row].documentID)
           navigationController?.pushViewController(userProfileVC, animated: true)
       }
   }
}
