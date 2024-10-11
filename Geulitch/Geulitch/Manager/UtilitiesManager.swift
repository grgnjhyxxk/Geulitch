//
//  UtilitiesManager.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/3/24.
//

import UIKit
import CryptoKit

class Utilities {
    static func formatPhoneNumber(_ phoneNumber: String) -> String {
        var formattedPhoneNumber = phoneNumber.trimmingCharacters(in: .whitespaces)
        if formattedPhoneNumber.hasPrefix("0") {
            formattedPhoneNumber.removeFirst()
        }
        return "+82 \(formattedPhoneNumber)"
    }
    
    static func hashPassword(_ password: String) -> String {
        let inputData = Data(password.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    static func imageFromProfileLink(profileImageLink: String?, completion: @escaping (UIImage?) -> Void) {
        // 프로필 이미지 링크가 비어있으면 기본 이미지 반환
        guard let link = profileImageLink, !link.isEmpty, let url = URL(string: link) else {
            completion(UIImage(named: "DefaultUserProfileImage"))
            return
        }
        
        // 이미지 다운로드
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("이미지 다운로드 오류: \(error)")
                completion(UIImage(named: "DefaultUserProfileImage")) // 오류 발생 시 기본 이미지 반환
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(UIImage(named: "DefaultUserProfileImage")) // 이미지 변환 실패 시 기본 이미지 반환
                return
            }
            
            // 다운로드 성공 시 이미지 반환
            completion(image)
        }
        
        task.resume()
    }
}
