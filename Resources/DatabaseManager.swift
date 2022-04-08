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
    
    static func safeEmail(emailAddress: String) -> String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
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
                
                self.database.child("users").observeSingleEvent(of: .value, with: { DataSnapshot in
                    if var userCollection = DataSnapshot.value as? [[String:String]]{
                        //append user dict
                        let newElemenet = [
                            "name": user.firstName + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                        userCollection.append(newElemenet)
                        self.database.child("users").setValue(userCollection, withCompletionBlock: { error, _ in
                            guard error == nil  else {
                                completion(false)
                                return
                            }
                            completion(true)
                        })
                    } else {
        
                        let newCollection: [[String:String]] = [
                            [
                                "name": user.firstName + " " + user.lastName,
                                "email": user.safeEmail
                            ]
                        ]
                        self.database.child("users").setValue(newCollection, withCompletionBlock: { error, _ in
                            guard error == nil  else {
                                completion(false)
                                return
                            }
                            completion(true)
                        })
                    }
                })
            })
    }
    
    public func getAllUsers(completion: @escaping (Result<[[String:String]], Error>) -> Void){
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String:String]] else {
                completion(.failure(DatabaseError.failedFetch))
                return
            }
            completion(.success(value))
            })
    }
    public enum DatabaseError: Error{
        case failedFetch
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
