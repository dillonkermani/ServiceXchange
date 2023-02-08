//
//  Ref.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/30/23.
//

import SwiftUI
import Firebase
import FirebaseStorage

class Ref {
    // Firestore
    static var FIRESTORE_ROOT = Firestore.firestore()
    
    // Firestore - Users
    static var FIRESTORE_COLLECTION_USERS = FIRESTORE_ROOT.collection("users")
    static func FIRESTORE_DOCUMENT_USERID(userId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_USERS.document(userId)
    }
    
    // Firestore - Listings
    static var FIRESTORE_COLLECTION_LISTINGS = FIRESTORE_ROOT.collection("listings")
    static func FIRESTORE_DOCUMENT_LISTINGID(listingId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_LISTINGS.document(listingId)
    }
    static var FIREBASE_STORAGE = Storage.storage()
}
