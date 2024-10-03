//
//  LoginConfig.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/2/24.
//

import UIKit

enum LoginConfig {
    case userId
    case password

    var titleIconImage: UIImage? {
        switch self {
        case .userId:
            return UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        case .password:
            return UIImage(systemName: "lock.shield")?.withRenderingMode(.alwaysOriginal)
        }
    }

    var titleLabelText: String {
        switch self {
        case .userId:
            return "아이디·전화번호"
        case .password:
            return "비밀번호"
        }
    }

    var textFieldPlaceholder: String {
        switch self {
        case .userId:
            return "아이디혹은 전화번호를 입력하세요."
        case .password:
            return "비밀번호를 입력하세요."
        }
    }
}

