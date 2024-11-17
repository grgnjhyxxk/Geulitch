//
// RecommendedUserViewModel.swift
// Geulitch
//
// Created by Jaehyeok Lim on 11/14/24.
//

class RecommendedUserViewModel {
    func fetchRecommendedUsers(completion: @escaping (Result<[UserData], Error>) -> Void) {
        NetworkManager.shared.fetchRecommendedUsers { result in
            switch result {
            case .success(let users):
                completion(.success(users))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
