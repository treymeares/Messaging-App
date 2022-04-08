//
//  StorageManager.swift
//  Sp22_Message_App
//
//  Created by Trey Meares on 4/6/22.
//

import Foundation
import FirebaseStorage

final class StorageManager{
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    ///Uploading pic to FB storage and retruning completion with url string to download to app
    public func uploadProfilePic(with data: Data, fileName: String, completionHandler: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata:nil, completion: { metadata, error in
            guard error == nil else {
                //failed
                completionHandler(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else{
                    completionHandler(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                let urlString = url.absoluteString
                print(urlString)
                completionHandler(.success(urlString))
            })
        })
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadURL
    }
    
    public func downloadUrl(for path: String, completion: @escaping (Result<URL, Error>)-> Void) {
        let reference = storage.child(path)
        reference.downloadURL(completion: {url, error in
            guard let url = url, error == nil else{
                completion(.failure(StorageErrors.failedToGetDownloadURL))
                return
            }
            completion(.success(url))
        })
    }
}
