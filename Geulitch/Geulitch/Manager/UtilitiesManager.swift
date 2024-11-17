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
}
