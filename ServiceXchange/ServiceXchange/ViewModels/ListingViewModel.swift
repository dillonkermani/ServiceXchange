//
//  ListingViewModel.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/31/23.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseStorage

class ListingViewModel: ObservableObject {
        
    @Published var cardImageData: Data = Data()
    @Published var cardImageUrl: String = ""
    @Published var posterId: String = ""
    @Published var title: String = ""
    @Published var description: String = ""
    
    func loadAllListings(onSuccess: @escaping(_ listings: [Listing]) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        Ref.FIRESTORE_COLLECTION_LISTINGS.order(by: "name", descending: true).getDocuments { (snapshot, error) in
            guard let snap = snapshot else {
                print("Error fetching data")
                return
            }
            
            var listings: [Listing] = []
            
            for document in snap.documents {
                let dict = document.data()
                guard let decodedListing = try? Listing.init(fromDictionary: dict) else { return }
                listings.append(decodedListing)
            }
            
            onSuccess(listings)
        }
    }
    
    func addListing(onSuccess: @escaping(_ listing: Listing) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        let listingId = Ref.FIRESTORE_COLLECTION_LISTINGS.document().documentID
        let storage = Storage.storage()
        let image_name = "\(listingId).jpg"
        let img_ref = storage.reference().child(image_name)
        img_ref.putData(cardImageData) {(metadata, error) in
            guard let metadata = metadata else {
                print("uh oh spagetti oh")
                return
            }
            let size = metadata.size
            img_ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                print(downloadURL)
            }
        }

        let listing = Listing(listingId: listingId, posterId: self.posterId, cardImageUrl: self.cardImageUrl, title: self.title, description: self.description, datePosted: Date().timeIntervalSince1970)
        
        guard let dict = try? listing.toDictionary() else { return }
        
        Ref.FIRESTORE_COLLECTION_LISTINGS.addDocument(data: dict) { (error) in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            
            onSuccess(listing)
        }
    }
    
}
