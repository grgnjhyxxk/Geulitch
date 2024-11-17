//
//  ProfileViewModel.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/27/24.
//

class ProfileViewModel {
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }

    func fetchLoggedInUser(completion: @escaping (Result<UserData, Error>) -> Void) {
        networkManager.fetchLoggedInUser { result in
            switch result {
            case .success(let user):
                print("\nFetched user: \n DocumentID: \(user.documentID)\n UserID: \(user.userID.value)\n PenName: \(user.penName.value)\n Introduction: \(user.introduction.value)\n")
                completion(.success(user))
            case .failure(let error):
                print("Error fetching user: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    func fetchUser(documentID: String, completion: @escaping (Result<UserData, Error>) -> Void) {
        networkManager.fetchUser(documentID: documentID) { result in
            switch result {
            case .success(let user):
                print("\nFetched user: \n DocumentID: \(user.documentID)\n UserID: \(user.userID.value)\n PenName: \(user.penName.value)\n Introduction: \(user.introduction.value)\n")
                completion(.success(user))
            case .failure(let error):
                print("Error fetching user: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
