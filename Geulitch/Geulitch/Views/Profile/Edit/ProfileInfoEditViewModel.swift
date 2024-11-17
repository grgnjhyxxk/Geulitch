//
//  ProfileInfoEditViewModel.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 11/8/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileInfoEditViewModel {
    func checkIfUsernameExists(username: String, completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.checkIfUsernameExists(username: username.lowercased()) { isDuplicate in
            completion(isDuplicate)
        }
    }
    
    func updateUserID(newUserID: String, documentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.updateUserID(newUserID: newUserID, documentID: documentID) { result in
            completion(result)
        }
    }
    
    func updatePenName(newPenName: String, documentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.updatePenName(newPenName: newPenName, documentID: documentID) { result in
            completion(result)
        }
    }
    
    func updateIntroduction(newIntroduction: String, documentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.updateIntroduction(newIntroduction: newIntroduction, documentID: documentID) { result in
            completion(result)
        }
    }
    
    func updateUserProfileImage(newProfileImage: UIImage, documentID: String, completion: @escaping (Result<String, Error>) -> Void) {
         NetworkManager.shared.updateProfileImage(image: newProfileImage, documentID: documentID) { result in
             completion(result)
         }
     }
    
    func deleteProfileImage(documentID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.deleteProfileImage(documentID: documentID) { result in
            completion(result)
        }
    }
}
