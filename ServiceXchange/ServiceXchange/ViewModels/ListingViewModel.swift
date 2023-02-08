//
//  ListingViewModel.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/31/23.
//

import Foundation
import SwiftUI
import FirebaseCore

class ListingViewModel: ObservableObject {
    
    //for displaying all listings
    @Published var allListings: [Listing] = []
    @Published var isLoading = false
    @Published var loadErrorMsg = ""
    
    //for uploading listings
    @Published var cardImageData = Data()
    @Published var posterId: String = ""
    @Published var title: String = ""
    @Published var description: String = ""
    
    func loadListings() {
        self.isLoading = true
        getListingsFromDB(onSuccess: {listings in
            self.allListings = listings
            self.isLoading = false
        }, onError: {errorMessage in
            self.loadErrorMsg = errorMessage
            self.isLoading = false
        })
    }
        
    private func getListingsFromDB(onSuccess: @escaping(_ listings: [Listing]) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        Ref.FIRESTORE_COLLECTION_LISTINGS.getDocuments { (snapshot, error) in
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
    
    func addListing(posterId: String, onSuccess: @escaping(_ listing: Listing) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        
        
        let listing = Listing(posterId: posterId, title: self.title, description: self.description, datePosted: Date().timeIntervalSince1970)
        
        guard let dict = try? listing.toDictionary() else { return }
        
        //adding listing without the image to the firebase
        let listing_ref = Ref.FIRESTORE_COLLECTION_LISTINGS.addDocument(data: dict){ error in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
        }
        
        //check if there is an image to add
        if self.cardImageData.isEmpty {
            onSuccess(listing)
            return
        }
        
        //create semi unique to be changed later image name
        let image_name = "\(listing_ref.documentID).jpg"
        
        //this a thing that you put image into and it updates image to firebase
        let img_ref = Ref.FIREBASE_STORAGE.reference().child(image_name)
        
        //give error if there is no image data
        img_ref.putData(self.cardImageData) {(metadata, error) in
            guard let _ = metadata else {
                print("no image metadata...")
                return
            }
            
            //gives us image url on success
            img_ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("image upload failed: no download url")
                    return
                }
                
                //store the url of the image to firebase
                listing_ref.updateData( [
                    "cardImageUrl": downloadURL.absoluteString,
                    "listingId": listing_ref.documentID,
                ] )
            }
                
        }
        onSuccess(listing)
    }
}
