//
//  NetworkManager.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/3/24.
//

import FirebaseAuth
import FirebaseFirestore

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
    func addUser(data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").addDocument(data: data) { error in
            if let error = error {
                print("Error adding user: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // 유저의 아이디/프로필이미지 가져오는 함수
    func fetchUserData(phoneNumber: String, completion: @escaping (Result<(userDocument: DocumentSnapshot, userID: String, profileImage: UIImage), Error>) -> Void) {
        
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

            // 이미지 다운로드 요청
            Utilities.imageFromProfileLink(profileImageLink: profileImageLink) { profileImage in
                // 메인 스레드에서 completion 호출
                DispatchQueue.main.async {
                    completion(.success((userDocument: document, userID: userID, profileImage: profileImage ?? UIImage(named: "DefaultUserProfileImage")!)))
                }
            }
        }
    }
    
    func updatePassword(document: DocumentSnapshot, newHashedPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // 문서 참조를 사용하여 비밀번호 업데이트
        document.reference.updateData(["password": newHashedPassword]) { error in
            if let error = error {
                completion(.failure(error)) // 업데이트 실패 시 오류 반환
            } else {
                completion(.success(())) // 성공적으로 업데이트
            }
        }
    }
    
    func autoLogin(completion: @escaping (UIViewController) -> Void) {
        // UserDefaults에서 자동 로그인 정보 가져오기
        guard let phoneNumber = UserDefaults.standard.string(forKey: "autoLoginPhoneNumber"),
              let password = UserDefaults.standard.string(forKey: "autoLoginPassword") else {
            // 자동 로그인 정보가 없으면 인증 화면 반환
            completion(UINavigationController(rootViewController: AuthenticationViewController()))
            return
        }
        
        // 전화번호로 사용자 문서 찾기
        db.collection("users").whereField("phoneNumber", isEqualTo: phoneNumber).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                // 오류 발생 시 인증 화면 반환
                completion(UINavigationController(rootViewController: AuthenticationViewController()))
                return
            }
            
            guard let documents = snapshot?.documents, let document = documents.first else {
                // 문서가 없으면 인증 화면 반환
                completion(UINavigationController(rootViewController: AuthenticationViewController()))
                return
            }
            
            // 유저 문서가 존재하고 비밀번호가 일치하는지 확인
            guard let storedPassword = document.data()["password"] as? String else {
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
}
