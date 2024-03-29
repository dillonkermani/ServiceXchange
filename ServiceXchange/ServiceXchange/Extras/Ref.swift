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
    
    // Firestore - Chats
    static var FIRESTORE_COLLECTION_CHATS = FIRESTORE_ROOT.collection("chats")
    static func FIRESTORE_DOCUMENT_CHATID(chatId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_CHATS.document(chatId)
    }
    
    // Firestore - Messages
    static var FIRESTORE_COLLECTION_MESSAGES = FIRESTORE_ROOT.collection("messages")
    static func FIRESTORE_DOCUMENT_MESSAGEID(messageId: String) -> DocumentReference {
        return FIRESTORE_COLLECTION_MESSAGES.document(messageId)
    }
    
    static var FIREBASE_STORAGE = Storage.storage()
}
