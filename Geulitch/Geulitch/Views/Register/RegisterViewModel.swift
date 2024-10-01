//
//  RegisterViewModel.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/25/24.
//
import UIKit
import FirebaseAuth
import FirebaseFirestore
import CryptoKit

class RegisterViewModel {
    private var registrationModel = RegistrationModel()
    private let db = Firestore.firestore()
    
    func updatePhoneNumber(_ phoneNumber: String) {
        registrationModel.phoneNumber = formatPhoneNumber(phoneNumber)
    }
        
    func updateUserId(_ penName: String) {
        registrationModel.userID = penName
    }
    
    func updatePenName(_ penName: String) {
        registrationModel.penName = penName
    }
    
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        var formattedPhoneNumber = phoneNumber.trimmingCharacters(in: .whitespaces)
        if formattedPhoneNumber.hasPrefix("0") {
            formattedPhoneNumber.removeFirst()
        }
        return "+82 \(formattedPhoneNumber)"
    }
    
    func sendVerificationCode(completion: @escaping (String?) -> Void) {
        guard let phoneNumber = registrationModel.phoneNumber else {
            completion(nil)
            return
        }
        
        print("입력 전화번호: \(registrationModel.phoneNumber)")
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            completion(verificationID)
        }
    }
    
    func checkIfPhoneNumberExists(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        let formattedPhoneNumber = formatPhoneNumber(phoneNumber) // 전화번호 포맷 적용
        let usersCollection = db.collection("users")
        
        usersCollection.whereField("phoneNumber", isEqualTo: formattedPhoneNumber).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error checking phone number: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(!(querySnapshot?.isEmpty ?? true)) // 중복된 번호가 있으면 true 반환
            }
        }
    }
    
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
        
    func checkIfUsernameExists(username: String, completion: @escaping (Bool) -> Void) {
        let usersCollection = db.collection("users")
        
        usersCollection.whereField("username", isEqualTo: username.lowercased()).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error checking username: \(error.localizedDescription)")
                completion(false) // 에러 발생 시 false로 전달
            } else {
                if querySnapshot?.isEmpty == false {
                    completion(true) // 중복된 아이디가 있음
                } else {
                    completion(false) // 중복된 아이디가 없음
                }
            }
        }
    }
    
    // 비밀번호 설정 및 해싱
    func setPassword(_ password: String) {
        registrationModel.password = hashPassword(password) // 해시된 비밀번호를 저장
        print("Hashed password stored: \(registrationModel.password!)")
    }
    
    // SHA-256 해시 함수
    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
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

        // 예시로 Firestore에 저장
        db.collection("users").addDocument(data: [
            "phoneNumber": phoneNumber,
            "userID": userID,
            "password": password,
            "penName": penName
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
                completion(.failure(error))  // 에러 발생 시 completion으로 에러 전달
            } else {
                print("회원가입 성공")
                completion(.success(()))  // 성공 시 completion으로 성공 반환
            }
        }
    }
}


