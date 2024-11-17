//
//  UserProfileModel.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/25/24.
//

import RxSwift
import RxCocoa

struct UserData {
    let documentID: String
    let userID: BehaviorRelay<String>
    let penName: BehaviorRelay<String>
    let introduction: BehaviorRelay<String>
    let userProfileImage: BehaviorRelay<String?>
    let follower: BehaviorRelay<[String]>
    let privacySetting: BehaviorRelay<Bool>
}

final class LoggedInUserManager {    
    // 싱글톤 인스턴스 생성
    static let shared = LoggedInUserManager()
    
    // 전역으로 관리되는 LoggedInUser
    private var _loggedInUser: BehaviorRelay<UserData?> = BehaviorRelay(value: nil)
    
    // 외부에서 접근 가능한 Observable
    var loggedInUser: Observable<UserData?> {
        return _loggedInUser.asObservable()
    }
    
    // private init으로 외부에서 직접 인스턴스 생성 방지
    private init() { }
    
    // LoggedInUser를 설정하는 함수
    func setLoggedInUser(_ user: UserData) {
        _loggedInUser.accept(user)
    }
    
    // LoggedInUser를 리셋하는 함수
    func clearLoggedInUser() {
        _loggedInUser.accept(nil)
    }
    
    // userID 업데이트 메소드
    func updateUserID(to newUserID: String) {
        guard let user = _loggedInUser.value else { return }
        user.userID.accept(newUserID) // LoggedInUser의 userID를 업데이트
    }
    
    // penName 업데이트 메소드
    func updatePenName(to newPenName: String) {
        guard let user = _loggedInUser.value else { return }
        user.penName.accept(newPenName) // LoggedInUser의 penName을 업데이트
    }
    
    func updateIntroduction(to newIntroduction: String) {
        guard let user = _loggedInUser.value else { return }
        user.introduction.accept(newIntroduction) // LoggedInUser의 introduction을 업데이트
    }
    
    func updateUserProfileImage(to newImageURL: String) {
        guard let user = _loggedInUser.value else { return }
        user.userProfileImage.accept(newImageURL) // URL을 업데이트
    }
    
    func getDocumentID() -> String? {
        return _loggedInUser.value?.documentID
    }
    
    func getUserID() -> String? {
        return _loggedInUser.value?.userID.value
    }

    func getPenName() -> String? {
        return _loggedInUser.value?.penName.value
    }

    func getIntroduction() -> String? {
        return _loggedInUser.value?.introduction.value
    }
}

protocol UserManagerProtocol {
    func updateUser(_ user: UserData)
    func getDocumentID() -> String?  // documentID를 반환하는 메소드 추가
}

final class RecommendedUsersManager: UserManagerProtocol {
    static let shared = RecommendedUsersManager()
    
    private var _recommendedUsers: BehaviorRelay<[UserData]> = BehaviorRelay(value: [])
    
    var recommendedUsers: Observable<[UserData]> {
        return _recommendedUsers.asObservable()
    }
    
    private init() { }
    
    func setRecommendedUsers(_ users: [UserData]) {
        _recommendedUsers.accept(users)
    }
    
    func addRecommendedUser(_ user: UserData) {
        var users = _recommendedUsers.value
        users.append(user)
        _recommendedUsers.accept(users)
    }
    
    func clearRecommendedUsers() {
        _recommendedUsers.accept([])
    }
    
    func updateUser(_ user: UserData) {
        var users = _recommendedUsers.value

        if let index = users.firstIndex(where: { $0.documentID == user.documentID }) {
            users[index] = user
        }
            
        _recommendedUsers.accept(users)
    }
    
    func getDocumentID() -> String? {
        return _recommendedUsers.value.first?.documentID  // 첫 번째 유저의 documentID 반환
    }
}

final class SearchResultsUsersManager: UserManagerProtocol {
    static let shared = SearchResultsUsersManager()
    
    private var _searchResultsUsers: BehaviorRelay<[UserData]> = BehaviorRelay(value: [])
    
    var searchResultsUsers: Observable<[UserData]> {
        return _searchResultsUsers.asObservable()
    }
    
    private init() { }
    
    func setSearchResultsUsers(_ users: [UserData]) {
        _searchResultsUsers.accept(users)
    }
    
    func addSearchResultUser(_ user: UserData) {
        var users = _searchResultsUsers.value
        users.append(user)
        _searchResultsUsers.accept(users)
    }
    
    func clearSearchResultsUsers() {
        _searchResultsUsers.accept([])
    }
    
    func updateUser(_ user: UserData) {
        var users = _searchResultsUsers.value
        
        if let index = users.firstIndex(where: { $0.documentID == user.documentID }) {
            users[index] = user
        }
                
        _searchResultsUsers.accept(users)
    }
    
    func getDocumentID() -> String? {
        return _searchResultsUsers.value.first?.documentID  // 첫 번째 유저의 documentID 반환
    }
}

class DefaultUserManager: UserManagerProtocol {
    func updateUser(_ user: UserData) {
        print("Default user manager updateUser called")
    }
    
    func getDocumentID() -> String? {
        return "defaultDocumentID"
    }
}
