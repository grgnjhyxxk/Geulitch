//
//  LoginViewModel.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/2/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CryptoKit

class LoginViewModel {
    private var loginModel = LoginModel()
    private let db = Firestore.firestore()
    
    func updatePhoneNumber(_ phoneNumber: String) {
        loginModel.phoneNumber = formatPhoneNumber(phoneNumber)
    }
    
    func updateUserId(_ userID: String) {
        loginModel.userID = userID
    }
    
    func setPassword(_ password: String) {
        loginModel.password = hashPassword(password)
        print("Hashed password stored: \(loginModel.password!)")
    }
    
    private func formatPhoneNumber(_ phoneNumber: String) -> String {
        var formattedPhoneNumber = phoneNumber.trimmingCharacters(in: .whitespaces)
        if formattedPhoneNumber.hasPrefix("0") {
            formattedPhoneNumber.removeFirst()
        }
        return "+82 \(formattedPhoneNumber)"
    }
    
    private func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    // Firestore에서 사용자 확인 및 비밀번호 비교
    func login(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userID = loginModel.userID, let password = loginModel.password else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "아이디 또는 비밀번호가 없습니다."])))
            return
        }
        
        let usersCollection = db.collection("users")
        
        // 아이디로 로그인
        usersCollection.whereField("userID", isEqualTo: userID.lowercased()).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = querySnapshot?.documents.first,
                  let storedPassword = document.data()["password"] as? String else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "아이디가 존재하지 않습니다."])))
                return
            }
            
            if storedPassword == password {
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "비밀번호가 일치하지 않습니다."])))
            }
        }
    }
    
    // 전화번호로 로그인
    func loginWithPhoneNumber(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let phoneNumber = loginModel.phoneNumber, let password = loginModel.password else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "전화번호 또는 비밀번호가 없습니다."])))
            return
        }
        
        let usersCollection = db.collection("users")
        
        // 전화번호로 로그인
        usersCollection.whereField("phoneNumber", isEqualTo: phoneNumber).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = querySnapshot?.documents.first,
                  let storedPassword = document.data()["password"] as? String else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "전화번호가 존재하지 않습니다."])))
                return
            }
            
            if storedPassword == password {
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "비밀번호가 일치하지 않습니다."])))
            }
        }
    }
}
