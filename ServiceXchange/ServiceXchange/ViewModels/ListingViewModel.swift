//
//  ListingViewModel.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/31/23.
//

import Foundation

class ListingViewModel: ObservableObject {
    
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
    
    func addListing(posterId: String, coverImage: URL, title: String, description: String, onSuccess: @escaping(_ listing: Listing) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        let listingId = Ref.FIRESTORE_COLLECTION_LISTINGS.document().documentID

        
        let listing = Listing(listingId: listingId, posterId: posterId, coverImage: coverImage, title: title, description: description)
        
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
