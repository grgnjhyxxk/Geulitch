//
//  FindAccoutViewModel.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/10/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FindAccoutViewModel {
    private var findAccountModel = FindAccountModel()

    // 전화번호 업데이트 (Utilities 사용)
    func updatePhoneNumber(_ phoneNumber: String) {
        findAccountModel.phoneNumber = Utilities.formatPhoneNumber(phoneNumber)
    }
    
    // 아이디 업데이트
    func updateUserId(_ penName: String) {
        findAccountModel.userID = penName.lowercased()
    }

    // 유저 프로필 이미지 업데이트
    func updateUserProfileImage(_ userProfileImage: UIImage) {
        findAccountModel.userProfileImage = userProfileImage
    }
    
    // 유저 프로필 이미지 업데이트
    func updateUserDocument(_ userDocument: DocumentSnapshot) {
        findAccountModel.userDocument = userDocument
    }
    
    func getUserAccount() -> (userID: String, userProfileImage: UIImage)? {
        guard let userID = findAccountModel.userID,
              let userProfileImage = findAccountModel.userProfileImage else {
            return nil
        }
        return (userID, userProfileImage)
    }
    
    // 인증 코드 발송 (NetworkManager 사용)
    func sendVerificationCode(completion: @escaping (String?) -> Void) {
        guard let phoneNumber = findAccountModel.phoneNumber else {
            completion(nil)
            return
        }
        
        print("입력 전화번호: \(phoneNumber)")
        NetworkManager.shared.sendVerificationCode(phoneNumber: phoneNumber) { verificationID in
            completion(verificationID)
        }
    }
    
    // 회원정보 찾기 (NetworkManager 사용)
    func fetchUserData(completion: @escaping (Result<(userDocument: DocumentSnapshot, userID: String, profileImage: UIImage), Error>) -> Void) {
        if let phoneNumber = findAccountModel.phoneNumber {
            NetworkManager.shared.fetchUserData(phoneNumber: phoneNumber) { result in
                completion(result)
            }
        } else {
            print("FoundAccountModel PhoneNumber Error")
        }
    }
    
    // 인증 코드 검증 (NetworkManager 사용)
    func verifyCode(verificationID: String, verificationCode: String, completion: @escaping (Result<User, Error>) -> Void) {
        NetworkManager.shared.verifyCode(verificationID: verificationID, verificationCode: verificationCode) { result in
            completion(result)
        }
    }
    
    // 새로운 비밀번호 설정 및 해싱 (Utilities 사용)
    func setNewPassword(_ password: String) {
        findAccountModel.newPassword = Utilities.hashPassword(password)
        print("Hashed new password stored: \(findAccountModel.newPassword!)")
    }
    
    // 비밀번호 업데이트 함수
    func updatePassword(completion: @escaping (Result<Void, Error>) -> Void) {
        // newHashedPassword와 userDocument가 유효한지 확인
        guard let newHashedPassword = findAccountModel.newPassword,
              let userDocument = findAccountModel.userDocument else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "유효하지 않은 사용자 데이터"])))
            return
        }
        
        // NetworkManager의 updatePassword 호출
        NetworkManager.shared.updatePassword(document: userDocument, newHashedPassword: newHashedPassword) { result in
            completion(result) // NetworkManager의 결과 반환
        }
    }
}
