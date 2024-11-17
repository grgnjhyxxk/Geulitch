//
//  LaunchViewModel.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/26/24.
//

import UIKit
import RxSwift

class LaunchViewModel {
    private let networkManager: NetworkManager
    private let disposeBag = DisposeBag() // DisposeBag 추가

    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func autoLogin(completion: @escaping (Bool) -> Void) {
        networkManager.autoLogin { viewController in
            if viewController is UINavigationController {
                completion(false) // 인증 화면을 반환할 경우 false
            } else if viewController is TabBarController {
                completion(true) // TabBarController를 반환할 경우 true
            } else {
                completion(false) // 예상하지 못한 경우에도 false 반환
            }
        }
    }

    // 사용자 정보를 가져오는 함수 추가
    func fetchLoggedInUser(completion: @escaping (Result<UserData, Error>) -> Void) {
        networkManager.fetchLoggedInUser { result in
            switch result {
            case .success(let user):
                print("\nFetched user: \n DocumentID: \(user.documentID)\n UserID: \(user.userID.value)\n PenName: \(user.penName.value)\n Introduction: \(user.introduction.value)\n Follower: \(user.follower.value)")
                completion(.success(user))
            case .failure(let error):
                print("Error fetching user: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
