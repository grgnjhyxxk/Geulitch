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
    case introcution
    
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
        case .introcution:
            return UIImage(systemName: "doc.plaintext")?.withRenderingMode(.alwaysOriginal)
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
        case .introcution:
            return "자기소개"
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
        case .introcution:
            return "자기소개를 입력하세요."
        }
    }

    var textFieldExplainLabelText: String {
        switch self {
        case .phoneNumber:
            return "휴대폰 번호는 계정 인증 및 보안 목적으로 사용됩니다. 동일한 번호로 두 개 이상의 아이디를 가질 수 없습니다."
        case .verificationCode:
            return "SMS로 발송된 인증번호를 입력하세요. 입력 시간을 초과하거나 실패가 반복될 시 보류될 수 있습니다.\n\n인증번호 재인증은 1분마다 가능합니다."
        case .userId:
            return "알파벳과 숫자, 특수문자(_ .)를 사용할 수 있습니다. 마침표는 처음과 끝에 위치할 수 없습니다."
        case .password:
            return "비밀번호는 6자리 이상 최대 128자리까지 입력 가능합니다."
        case .penName:
            return "필명은 중복이 가능합니다."
        case .introcution:
            return "자유롭게 나를 소개하세요."
        }
    }
    
    var maxCharacterLimit: Int {
        switch self {
        case .phoneNumber:
            return 11
        case .verificationCode:
            return 6
        case .userId:
            return 20
        case .password:
            return 128
        case .penName:
            return 20
        case .introcution:
            return 100
        }
    }
}
