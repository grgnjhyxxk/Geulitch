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
    
    func login(userIdentifier: String, isPhoneNumber: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let password = loginModel.password else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "비밀번호가 없습니다."])))
            return
        }

        let usersCollection = db.collection("users")

        // 아이디 또는 전화번호로 로그인
        if isPhoneNumber {
            // 전화번호로 로그인
            usersCollection.whereField("phoneNumber", isEqualTo: userIdentifier).getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let document = querySnapshot?.documents.first,
                      let storedPassword = document.data()["password"] as? String else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "전화번호가 존재하지 않습니다."])))
                    return
                }

                self.comparePassword(storedPassword: storedPassword, enteredPassword: password, completion: { result in
                    if case .success = result {
                        // 비밀번호가 맞으면 자동 로그인 정보 저장
                        UserDefaults.standard.set(userIdentifier, forKey: "autoLoginPhoneNumber")
                        UserDefaults.standard.set(password, forKey: "autoLoginPassword") // 비밀번호 저장
                    }
                    completion(result)
                })
            }
        } else {
            // 아이디로 로그인
            usersCollection.whereField("userID", isEqualTo: userIdentifier.lowercased()).getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let document = querySnapshot?.documents.first,
                      let storedPassword = document.data()["password"] as? String else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "아이디가 존재하지 않습니다."])))
                    return
                }

                // 아이디로 로그인한 경우, 전화번호 가져오기
                if let phoneNumber = document.data()["phoneNumber"] as? String {
                    UserDefaults.standard.set(phoneNumber, forKey: "autoLoginPhoneNumber")
                }

                self.comparePassword(storedPassword: storedPassword, enteredPassword: password, completion: { result in
                    if case .success = result {
                        UserDefaults.standard.set(password, forKey: "autoLoginPassword") // 비밀번호 저장
                    }
                    completion(result)
                })
            }
        }
    }

    // 비밀번호 비교 함수
    private func comparePassword(storedPassword: String, enteredPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        if storedPassword == enteredPassword {
            completion(.success(()))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "비밀번호가 일치하지 않습니다."])))
        }
    }
}
