//
//  NetworkManager.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/3/24.
//

import FirebaseAuth
import FirebaseFirestore
import RxSwift
import RxRelay
import FirebaseStorage

class NetworkManager {
    static let shared = NetworkManager()
    private let db = Firestore.firestore()
    
    // 인증 코드 발송
    func sendVerificationCode(phoneNumber: String, completion: @escaping (String?) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(verificationID)
        }
    }
    
    // 전화번호 중복 체크
    func checkIfPhoneNumberExists(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").whereField("phoneNumber", isEqualTo: phoneNumber).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error checking phone number: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(!(querySnapshot?.isEmpty ?? true))
            }
        }
    }
    
    // 아이디 중복 체크
    func checkIfUsernameExists(username: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").whereField("userID", isEqualTo: username.lowercased()).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error checking username: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(!(querySnapshot?.isEmpty ?? true))
            }
        }
    }
    
    // 인증 코드 검증
    func verifyCode(verificationID: String, verificationCode: String, completion: @escaping (Result<User, Error>) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }
    
    // Firestore에 사용자 추가
    func addUser(data: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        // 새 문서의 참조 생성
        let newDocumentRef = db.collection("users").document()
        
        // 문서에 데이터 추가
        newDocumentRef.setData(data) { error in
            if let error = error {
                print("Error adding user: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                // 성공적으로 추가된 경우 documentID를 반환
                completion(.success(newDocumentRef.documentID))
            }
        }
    }
    
    // 유저의 아이디/프로필이미지 가져오는 함수
    func fetchUserDataForFindAccount(phoneNumber: String, completion: @escaping (Result<(userDocumentID: String, userID: String, profileImage: String), Error>) -> Void) {
        
        // 전화번호로 사용자 문서 찾기
        db.collection("users").whereField("phoneNumber", isEqualTo: phoneNumber).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents, let document = documents.first else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "유저 데이터가 유효하지 않습니다."])))
                return
            }
            
            guard let userID = document.data()["userID"] as? String,
                  let profileImageLink = document.data()["profileImage"] as? String else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "유저 데이터가 유효하지 않습니다."])))
                return
            }
            
            // 문서 ID, userID, 프로필 이미지 링크 반환
            completion(.success((userDocumentID: document.documentID, userID: userID, profileImage: profileImageLink)))
        }
    }
    
    func updatePassword(documentID: String, newHashedPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // documentID로 문서 참조 얻기
        let documentRef = db.collection("users").document(documentID)
        
        // 비밀번호 업데이트
        documentRef.updateData(["password": newHashedPassword]) { error in
            if let error = error {
                completion(.failure(error)) // 업데이트 실패 시 오류 반환
            } else {
                completion(.success(())) // 성공적으로 업데이트
            }
        }
    }
    
    func autoLogin(completion: @escaping (UIViewController) -> Void) {
        // UserDefaults에서 자동 로그인 정보 가져오기
        guard let documentID = UserDefaults.standard.string(forKey: "autoLoginDocumentID"),
              let password = UserDefaults.standard.string(forKey: "autoLoginPassword") else {
            // 자동 로그인 정보가 없으면 인증 화면 반환
            completion(UINavigationController(rootViewController: AuthenticationViewController()))
            return
        }
        
        // documentID로 사용자 문서 가져오기
        let userDocumentRef = db.collection("users").document(documentID)
        userDocumentRef.getDocument { document, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                // 오류 발생 시 인증 화면 반환
                completion(UINavigationController(rootViewController: AuthenticationViewController()))
                return
            }
            
            guard let document = document, document.exists else {
                print("AutoLogin: 해당 문서가 없습니다.")
                completion(UINavigationController(rootViewController: AuthenticationViewController()))
                return
            }
            
            // 유저 문서가 존재하고 비밀번호가 일치하는지 확인
            guard let storedPassword = document.data()?["password"] as? String else {
                // 비밀번호 정보가 없으면 인증 화면 반환
                completion(UINavigationController(rootViewController: AuthenticationViewController()))
                return
            }
            
            // 비밀번호 비교
            if storedPassword == password {
                // 비밀번호가 일치하면 TabBarController 반환
                completion(TabBarController())
            } else {
                // 비밀번호가 일치하지 않으면 인증 화면 반환
                completion(UINavigationController(rootViewController: AuthenticationViewController()))
            }
        }
    }
    
    func fetchLoggedInUser(completion: @escaping (Result<UserData, Error>) -> Void) {
        // UserDefaults에서 documentID 가져오기
        guard let documentID = UserDefaults.standard.string(forKey: "autoLoginDocumentID") else {
            completion(.failure(NSError(domain: "Error", code: 404, userInfo: [NSLocalizedDescriptionKey: "Document ID not found."])))
            return
        }
        
        // Firestore 데이터베이스 참조
        let db = Firestore.firestore()
        
        // documentID로 사용자 문서 가져오기
        db.collection("users").document(documentID).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "Error", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found."])))
                return
            }
            
            // 문서 데이터 가져오기
            let userIDValue = document.data()?["userID"] as? String ?? ""
            let penNameValue = document.data()?["penName"] as? String ?? ""
            let introductionValue = document.data()?["introduction"] as? String ?? ""
            let follower = document.data()?["follower"] as? [String] ?? []
            let profileImageLink = document.data()?["profileImage"] as? String ?? ""
            let privacySetting = document.data()?["privacySetting"] as? Bool ?? false
            
            // 메인 스레드에서 completion 호출
            DispatchQueue.main.async {
                let relayUser = UserData(
                    documentID: documentID,
                    userID: BehaviorRelay(value: userIDValue),
                    penName: BehaviorRelay(value: penNameValue),
                    introduction: BehaviorRelay(value: introductionValue.isEmpty ? "" : introductionValue),
                    userProfileImage: BehaviorRelay(value: profileImageLink), // String으로 저장
                    follower: BehaviorRelay(value: follower),
                    privacySetting: BehaviorRelay(value: privacySetting)
                )
                
                completion(.success(relayUser))
            }
        }
    }
    
    // userID 업데이트 함수
    func updateUserID(newUserID: String, documentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // users 컬렉션에서 해당 documentID를 가진 문서 참조
        let userDocumentRef = db.collection("users").document(documentID)
        
        // 문서 업데이트
        userDocumentRef.updateData(["userID": newUserID]) { error in
            if let error = error {
                // 업데이트 실패 시 오류 반환
                completion(.failure(error))
            } else {
                // 성공적으로 업데이트되었을 때
                completion(.success(()))
            }
        }
    }
    
    // penName 업데이트 함수
    func updatePenName(newPenName: String, documentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // users 컬렉션에서 해당 documentID를 가진 문서 참조
        let userDocumentRef = db.collection("users").document(documentID)
        
        // 문서 업데이트
        userDocumentRef.updateData(["penName": newPenName]) { error in
            if let error = error {
                // 업데이트 실패 시 오류 반환
                completion(.failure(error))
            } else {
                // 성공적으로 업데이트되었을 때
                completion(.success(()))
            }
        }
    }
    
    // Introduction업데이트 함수
    func updateIntroduction(newIntroduction: String, documentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // users 컬렉션에서 해당 documentID를 가진 문서 참조
        let userDocumentRef = db.collection("users").document(documentID)
        
        // 문서 업데이트
        userDocumentRef.updateData(["introduction": newIntroduction]) { error in
            if let error = error {
                // 업데이트 실패 시 오류 반환
                completion(.failure(error))
            } else {
                // 성공적으로 업데이트되었을 때
                completion(.success(()))
            }
        }
    }
    
    // 프로필 이미지 업데이트 함수
    func updateProfileImage(image: UIImage, documentID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let storageRef = Storage.storage().reference().child("profile_images/\(documentID).jpg")
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "이미지 변환에 실패했습니다."])))
            return
        }
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error)) // 업로드 실패 시 오류 반환
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error)) // URL 가져오기 실패 시 오류 반환
                    return
                }
                
                guard let profileImageURL = url?.absoluteString else {
                    completion(.failure(NSError(domain: "URLError", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL 생성에 실패했습니다."])))
                    return
                }
                
                // Firestore에서 users 컬렉션의 해당 documentID에 profileImage 필드 업데이트
                let userDocumentRef = self.db.collection("users").document(documentID)
                userDocumentRef.updateData(["profileImage": profileImageURL]) { error in
                    if let error = error {
                        completion(.failure(error)) // Firestore 업데이트 실패 시 오류 반환
                    } else {
                        completion(.success(profileImageURL)) // 성공적으로 URL을 반환
                    }
                }
            }
        }
    }
    
    func deleteProfileImage(documentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let storageRef = Storage.storage().reference().child("profile_images/\(documentID).jpg")
        
        storageRef.delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            let userDocumentRef = self.db.collection("users").document(documentID)
            userDocumentRef.updateData(["profileImage": FieldValue.delete()]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    // 추천 사용자 목록 가져오기
    func fetchRecommendedUsers(completion: @escaping (Result<[UserData], Error>) -> Void) {
        db.collection("users").limit(to: 10).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            var recommendedUsers: [UserData] = []
            
            snapshot?.documents.forEach { document in
                let documentData = document.data()
                
                let userID = documentData["userID"] as? String ?? ""
                let penName = documentData["penName"] as? String ?? ""
                let introduction = documentData["introduction"] as? String ?? ""
                let profileImage = documentData["profileImage"] as? String ?? ""
                let privacySetting = documentData["privacySetting"] as? Bool ?? false

                
                let user = UserData(
                    documentID: document.documentID,
                    userID: BehaviorRelay(value: userID),
                    penName: BehaviorRelay(value: penName),
                    introduction: BehaviorRelay(value: introduction),
                    userProfileImage: BehaviorRelay(value: profileImage),
                    follower: BehaviorRelay(value: documentData["follower"] as? [String] ?? []),
                    privacySetting: BehaviorRelay(value: privacySetting)
                )
                
                recommendedUsers.append(user)
                
                // 모든 사용자 데이터가 처리된 후 완료 핸들러 호출
                if recommendedUsers.count == snapshot?.documents.count {
                    completion(.success(recommendedUsers))
                }
            }
        }
    }
    
    func searchUsers(with searchText: String, completion: @escaping (Result<[UserData], Error>) -> Void) {
        let usersRef = Firestore.firestore().collection("users")
        
        // 검색어를 소문자로 변환
        let normalizedSearchText = searchText.lowercased()
        
        // 검색어가 비어 있으면 빈 배열을 반환
        if normalizedSearchText.isEmpty {
            completion(.success([]))
            return
        }
        
        // userID에 대한 쿼리 (소문자로 변환된 검색어 사용)
        let userIDQuery = usersRef
            .whereField("userID", isGreaterThanOrEqualTo: normalizedSearchText)
            .whereField("userID", isLessThanOrEqualTo: normalizedSearchText + "\u{f8ff}")
            .order(by: "userID")

        // penName에 대한 쿼리 (소문자로 변환된 검색어 사용)
        // 유니코드 범위 처리를 통해 검색 범위를 넓히고
        let penNameQuery = usersRef
            .whereField("penName", isGreaterThanOrEqualTo: normalizedSearchText)
            .whereField("penName", isLessThanOrEqualTo: normalizedSearchText + "\u{f8ff}")
            .order(by: "penName")
        
        // 쿼리 결과를 비동기적으로 가져오기
        let group = DispatchGroup()
        var users: [UserData] = []
        var errorOccurred: Error?

        group.enter()
        userIDQuery.getDocuments { (snapshot, error) in
            if let error = error {
                errorOccurred = error
            } else {
                snapshot?.documents.forEach { document in
                    let data = document.data()
                    let user = UserData(documentID: document.documentID,
                                        userID: BehaviorRelay(value: data["userID"] as? String ?? ""),
                                        penName: BehaviorRelay(value: data["penName"] as? String ?? ""),
                                        introduction: BehaviorRelay(value: data["introduction"] as? String ?? ""),
                                        userProfileImage: BehaviorRelay(value: data["profileImage"] as? String ?? ""),
                                        follower: BehaviorRelay(value: data["follower"] as? [String] ?? []),
                                        privacySetting: BehaviorRelay(value: data["privacySetting"] as? Bool ?? true))
                    users.append(user)
                }
            }
            group.leave()
        }

        group.enter()
        penNameQuery.getDocuments { (snapshot, error) in
            if let error = error {
                errorOccurred = error
            } else {
                snapshot?.documents.forEach { document in
                    let data = document.data()
                    let user = UserData(documentID: document.documentID,
                                        userID: BehaviorRelay(value: data["userID"] as? String ?? ""),
                                        penName: BehaviorRelay(value: data["penName"] as? String ?? ""),
                                        introduction: BehaviorRelay(value: data["introduction"] as? String ?? ""),
                                        userProfileImage: BehaviorRelay(value: data["profileImage"] as? String ?? ""),
                                        follower: BehaviorRelay(value: data["follower"] as? [String] ?? []),
                                        privacySetting: BehaviorRelay(value: data["privacySetting"] as? Bool ?? true))
                    users.append(user)
                }
            }
            group.leave()
        }
        
        // 모든 쿼리가 완료되면 결과 반환
        group.notify(queue: .main) {
            if let error = errorOccurred {
                completion(.failure(error))
            } else {
                var uniqueUsersDict: [String: UserData] = [:]
                for user in users {
                    uniqueUsersDict[user.documentID] = user
                }
                let uniqueUsers = Array(uniqueUsersDict.values)
                
                completion(.success(uniqueUsers))
            }
        }
    }
    
    // 특정 사용자 정보를 가져오기
    func fetchUser(documentID: String, completion: @escaping (Result<UserData, Error>) -> Void) {
        db.collection("users").document(documentID).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = snapshot else {
                completion(.failure(NSError(domain: "DocumentError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document not found."])))
                return
            }
            
            let documentData = document.data()
            
            // 데이터 파싱
            let userID = documentData?["userID"] as? String ?? ""
            let penName = documentData?["penName"] as? String ?? ""
            let introduction = documentData?["introduction"] as? String ?? ""
            let profileImage = documentData?["profileImage"] as? String ?? ""
            let followers = documentData?["follower"] as? [String] ?? []
            let privacySetting = documentData?["privacySetting"] as? Bool ?? false

            DispatchQueue.main.async {
                // UserData 객체 생성
                let user = UserData(
                    documentID: document.documentID,
                    userID: BehaviorRelay(value: userID),
                    penName: BehaviorRelay(value: penName),
                    introduction: BehaviorRelay(value: introduction),
                    userProfileImage: BehaviorRelay(value: profileImage),
                    follower: BehaviorRelay(value: followers),
                    privacySetting: BehaviorRelay(value: privacySetting)
                )
                
                completion(.success(user))
            }
        }
    }
}
