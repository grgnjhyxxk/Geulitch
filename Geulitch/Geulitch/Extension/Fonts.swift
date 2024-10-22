//
//  Fonts.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 9/7/24.
//

import UIKit

extension UIFont {
    static func notoSansKR(size fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let familyName = "NotoSansKR"
        
        var weightString: String
        switch weight {
        case .black:
            weightString = "Black"
        case .bold:
            weightString = "Bold"
        case .heavy:
            weightString = "ExtraBold"
        case .ultraLight:
            weightString = "ExtraLight"
        case .light:
            weightString = "Light"
        case .medium:
            weightString = "Medium"
        case .regular:
            weightString = "Regular"
        case .semibold:
            weightString = "SemiBold"
        case .thin:
            weightString = "Thin"
        default:
            weightString = "Regular"
        }

        return UIFont(name: "\(familyName)-\(weightString)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: weight)
    }
    
    static func notoSans(size fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        let familyName = "NotoSans"
        
        var weightString: String
        switch weight {
        case .semibold:
            weightString = "semiBold"
        default:
            weightString = "semiBold"
        }
        
        return UIFont(name: "\(familyName)-\(weightString)", size: fontSize) ?? .systemFont(ofSize: fontSize, weight: weight)
    }
}
