//
//  ListingViewModel.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/31/23.
//

import Foundation
import SwiftUI
import FirebaseCore

//let skeletonUser = User(
//    userId: "",
//    firstName: "",
//    lastName: "",
//    email: "",
//    isServiceProvider: false,
//    listingIDs: []
//)

class ListingDetailViewModel: ObservableObject {
    
    @Published var loadingPoster = true
    //@Published var poster = skeletonUser
    
    @Published var poster = User(
        userId: "",
        firstName: "",
        lastName: "",
        email: "",
        isServiceProvider: false,
        listingIDs: []
    )
    
    @MainActor
    func getListingPoster(posterId: String) async {
        let user_ref = Ref.FIRESTORE_DOCUMENT_USERID(userId: posterId)
        do{
            let userDocument = try await user_ref.getDocument()
            guard let userDict = userDocument.data() else {
                print("invalid user")
                return
            }
            self.poster = try User(fromDictionary: userDict)
            self.loadingPoster = false
        }
        catch{
            print("couldn't load user \(posterId)")
            return
        }
    }

    
    func deleteListing(listing: Listing) {
        for imageUrl in listing.imageUrls {
            let httpsReference = Ref.FIREBASE_STORAGE.reference(forURL: imageUrl)
            
            let imageName = httpsReference.name
            // Create a reference to the file to delete
            let imageRef = Ref.FIREBASE_STORAGE.reference().child(imageName)
            
            // Delete the file
            imageRef.delete { error in
              if let error = error {
                // Uh-oh, an error occurred!
                print("Error deleting image from Storage: \(error)")
              } else {
                // File deleted successfully
                print("Successfully deleted \(imageUrl) from Storage.")
              }
            }
                
        }

        Ref.FIRESTORE_COLLECTION_LISTINGS.document(listing.listingId).delete()
    }
    
}
