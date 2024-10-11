//
//  FindAccountModel.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/10/24.
//

import UIKit
import FirebaseFirestore

struct FindAccountModel {
    var phoneNumber: String?
    var userDocument: DocumentSnapshot?
    var userID: String?
    var userProfileImage: UIImage?
    var newPassword: String?
    
}
