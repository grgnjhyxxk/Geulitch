//
//  RegistrationConfig.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/8/24.
//

import UIKit

enum RegistrationConfig {
    case phoneNumber
    case verificationCode
    case userId
    case password
    case penName

    var titleIconImage: UIImage? {
        switch self {
        case .phoneNumber:
            return UIImage(systemName: "iphone")?.withRenderingMode(.alwaysOriginal)
        case .verificationCode:
            return UIImage(systemName: "checkmark.seal")?.withRenderingMode(.alwaysOriginal)
        case .userId:
            return UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        case .password:
            return UIImage(systemName: "lock.shield")?.withRenderingMode(.alwaysOriginal)
        case .penName:
            return UIImage(systemName: "highlighter")?.withRenderingMode(.alwaysOriginal)
        }
    }

    var titleLabelText: String {
        switch self {
        case .phoneNumber:
            return "휴대폰 번호"
        case .verificationCode:
            return "본인 확인"
        case .userId:
            return "아이디"
        case .password:
            return "비밀번호"
        case .penName:
            return "필명"
        }
    }

    var textFieldPlaceholder: String {
        switch self {
        case .phoneNumber:
            return "휴대폰 번호를 입력하세요."
        case .verificationCode:
            return "휴대폰 인증 번호를 입력해주세요."
        case .userId:
            return "아이디를 입력하세요."
        case .password:
            return "비밀번호를 입력하세요."
        case .penName:
            return "필명을 입력하세요."
        }
    }

    var textFieldExplainLabelText: String {
        switch self {
        case .phoneNumber:
            return "휴대폰 번호는 계정 인증 및 보안 목적으로 사용됩니다. 동일한 번호로 두 개 이상의 아이디를 가질 수 없습니다."
        case .verificationCode:
            return "SMS로 발송된 인증번호를 입력하세요. 입력 시간을 초과하거나 실패가 반복될 시 보류될 수 있습니다."
        case .userId:
            return "아이디는 고유해야 합니다."
        case .password:
            return "안전한 비밀번호를 입력하세요."
        case .penName:
            return "필명은 다른 사람과 공유되지 않습니다."
        }
    }
}

