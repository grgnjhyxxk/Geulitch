//
//  EditConfig.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 11/5/24.
//

import UIKit

enum ProfileEditConfig: CaseIterable {
    case userId
    case penName
    case Introduction
    
    var titleLabelText: String {
        switch self {
        case .userId:
            return RegistrationConfig.userId.titleLabelText
        case .penName:
            return RegistrationConfig.penName.titleLabelText
        case .Introduction:
            return "자기소개"
        }
    }
}
