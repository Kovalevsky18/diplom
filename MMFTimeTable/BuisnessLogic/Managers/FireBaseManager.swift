//
//  FireBaseManager.swift
//  MMFTimeTable
//
//  Created by mac on 27.05.21.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol FireBaseManagerProtocol: AnyObject {
    func auth(login: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func fetch(userID: String, completion: @escaping (Result<FirebaseModel, Error>) -> Void)
}

class FireBaseManager: FireBaseManagerProtocol {
    let fireBaseCollection = Firestore.firestore()
    let decoder = JSONDecoder()
    let defaultError = NSError(domain: "error",
                               code: 12,
                               userInfo: nil)
    
    func auth(login: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        FirebaseAuth.Auth.auth().signIn(withEmail: login, password: password) { success, error in
            if let success = success {
                completion(.success(success.user.uid))
            } else {
                completion(.failure(error!))
            }
        }
    }
    
    func fetch(userID: String, completion: @escaping (Result<FirebaseModel, Error>) -> Void) {
        fireBaseCollection.collection("user").addSnapshotListener { [weak self] querySnapshot, error in
            guard let snapshot = querySnapshot,
                  let self = self else {
                return completion(.failure(error!))
            }
            
            for document in snapshot.documents {
                guard let uID = document.data()["userID"] as? String else { return }
                if uID == userID {
                    if let data = try?  JSONSerialization.data(withJSONObject: document.data(), options: []) {
                        let responseData = try? self.decoder.decode(FirebaseModel.self, from: data)
                        guard let responseData = responseData else { return  completion(.failure(self.defaultError)) } 
                        completion(.success(responseData))
                    }
                } else {
                    completion(.failure(self.defaultError))
                }
            }
        }
    }
}
