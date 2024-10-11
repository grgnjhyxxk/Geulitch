//
//  RegisterViewModel.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/25/24.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewModel {
    private var registrationModel = RegistrationModel()

    // 전화번호 업데이트 (Utilities 사용)
    func updatePhoneNumber(_ phoneNumber: String) {
        registrationModel.phoneNumber = Utilities.formatPhoneNumber(phoneNumber)
    }
    
    // 아이디 업데이트
    func updateUserId(_ penName: String) {
        registrationModel.userID = penName.lowercased()
    }
    
    // 필명 업데이트
    func updatePenName(_ penName: String) {
        registrationModel.penName = penName
    }

    // 인증 코드 발송 (NetworkManager 사용)
    func sendVerificationCode(completion: @escaping (String?) -> Void) {
        guard let phoneNumber = registrationModel.phoneNumber else {
            completion(nil)
            return
        }
        
        print("입력 전화번호: \(phoneNumber)")
        NetworkManager.shared.sendVerificationCode(phoneNumber: phoneNumber) { verificationID in
            completion(verificationID)
        }
    }
    
    // 전화번호 중복 체크 (NetworkManager 사용)
    func checkIfPhoneNumberExists(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        let formattedPhoneNumber = Utilities.formatPhoneNumber(phoneNumber)
        NetworkManager.shared.checkIfPhoneNumberExists(phoneNumber: formattedPhoneNumber) { isDuplicate in
            completion(isDuplicate)
        }
    }
    
    // 인증 코드 검증 (NetworkManager 사용)
    func verifyCode(verificationID: String, verificationCode: String, completion: @escaping (Result<User, Error>) -> Void) {
        NetworkManager.shared.verifyCode(verificationID: verificationID, verificationCode: verificationCode) { result in
            completion(result)
        }
    }

    // 아이디 중복 체크 (NetworkManager 사용)
    func checkIfUsernameExists(username: String, completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.checkIfUsernameExists(username: username.lowercased()) { isDuplicate in
            completion(isDuplicate)
        }
    }
    
    // 비밀번호 설정 및 해싱 (Utilities 사용)
    func setPassword(_ password: String) {
        registrationModel.password = Utilities.hashPassword(password)
        print("Hashed password stored: \(registrationModel.password!)")
    }

    // 회원가입 처리
    func signUp(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let phoneNumber = registrationModel.phoneNumber,
              let userID = registrationModel.userID,
              let password = registrationModel.password,
              let penName = registrationModel.penName else {
            print("회원가입 정보 누락")
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "회원가입 정보 누락"])))
            return
        }

        // 네트워크 요청을 통해 회원가입 처리
        print("Phone: \(phoneNumber), UserID: \(userID), Password: \(password), PenName: \(penName)")

        // Firestore에 저장
        let data: [String: Any] = [
            "phoneNumber": phoneNumber,
            "userID": userID,
            "password": password,
            "penName": penName,
            "profileImage": ""
        ]
        
        NetworkManager.shared.addUser(data: data) { result in
            switch result {
            case .success:
                print("회원가입 성공")
                completion(.success(()))
            case .failure(let error):
                print("회원가입 실패: \(error)")
                completion(.failure(error))
            }
        }
    }
}

