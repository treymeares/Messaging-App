//
//  DatabaseManager.swift
//  Sp22_Message_App
//
//  Created by Trey Meares on 4/4/22.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}
 //MARK: - Account Mgmt

extension DatabaseManager{
    
    public func checkForEmailExists(with email: String, completion: @escaping ((Bool) -> Void)) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value, with: {DataSnapshot in
            guard DataSnapshot.value as? String != nil else{
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    
    /// Insert New User To Database
    
    public func insertUser(with user: ChatAppUser, completion: @escaping (Bool) -> Void) {
        database.child(user.safeEmail).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName], withCompletionBlock: {error, _ in
                guard error == nil else{
                    print("failed to write to DB")
                    completion(false)
                    return
                }
                completion(true)
            })
    }
    
    struct ChatAppUser{
        let firstName: String
        let lastName: String
        let emailAddress: String
        
        var safeEmail: String {
            var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
            return safeEmail
        }
        
        var profilePictureFileName: String{
            return "\(safeEmail)_profile_picture.png"
        }
        //let profilePictureUrl: string
    }
    
}
