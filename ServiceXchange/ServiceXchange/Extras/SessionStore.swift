//
//  SessionStore.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/30/23.
//

import Foundation
import Combine
import FirebaseAuth
import Firebase

class SessionStore: ObservableObject {
    
    let db = Firestore.firestore()
    
    
    
    @Published var isLoggedIn = false
    @Published var isLoadingLogin = false
    @Published var isLoadingRefresh = false
    var userSession: User?
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func listenAuthenticationState() {
        self.isLoadingLogin = true
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                print(user.email ?? "")
                
                // Decode user and set userSession
                let firestoreUserId = Ref.FIRESTORE_DOCUMENT_USERID(userId: user.uid)
                  firestoreUserId.getDocument { (document, error) in
                      if let dict = document?.data() {
                        guard let decoderUser = try? User.init(fromDictionary: dict) else {return}
                        self.userSession = decoderUser
    
                          //self.loadLocalUserVariables()
                      }
                
                // Update fcmToken
                if let fcmToken = Messaging.messaging().fcmToken {
                    firestoreUserId.updateData( [
                        "fcmToken": fcmToken
                    ] )
                }
                
                firestoreUserId.getDocument { (document, error) in
                  if let dict = document?.data() {
                      guard let decoderUser = try? User.init(fromDictionary: dict) else {return}
                    self.userSession = decoderUser
                  }
                }
                self.isLoadingLogin = false
                print("Logged In")
                self.isLoggedIn = true
            } else {
                print("Logged Out")
                self.isLoadingLogin = false
                self.isLoggedIn = false
                self.userSession = nil
            }
        })
    }
    
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch  {
        
        }
    }
    
    func refreshUser() {
            if isLoggedIn {
                let firestoreUserId = Ref.FIRESTORE_DOCUMENT_USERID(userId: userSession!.userId)
                  firestoreUserId.getDocument { (document, error) in
                      if let dict = document?.data() {
                          guard let decoderUser = try? User.init(fromDictionary: dict) else {return}
                        self.userSession = decoderUser
                        print("Successfully refreshed user session.")
                      }
                  }
            } else {
                print("User isn't logged in. Cannot refresh user session.")
            }
            
        }
    
    func deleteUser() {
        print("Deleting user account \(Auth.auth().currentUser!.uid)")
        db.collection("users").document(Auth.auth().currentUser!.uid).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        Auth.auth().currentUser!.delete()
    }
    
    //stop listening for auth changes
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
    
    
    func refreshUserSession() {
        self.isLoadingRefresh = true
        guard let userId = userSession?.userId else { return }
        let firestoreUserId = Ref.FIRESTORE_DOCUMENT_USERID(userId: userId)
        firestoreUserId.getDocument { (document, error) in
            if let dict = document?.data() {
                guard let decoderUser = try? User.init(fromDictionary: dict) else { return }
                self.userSession = decoderUser
                print("User session refreshed")
                self.isLoadingRefresh = false
            }
        }
    }
}


