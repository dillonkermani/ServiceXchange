//
//  ListingViewModel.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/31/23.
//

import Foundation
import SwiftUI
import FirebaseCore
import Firebase
import FirebaseStorage

class ListingViewModel: ObservableObject {
    
    //for displaying all listings
    @Published var allListings: [Listing] = []
    @Published var isLoading = false
    @Published var loadErrorMsg = ""
    
    //for uploading listings
    var imageData = Data()
    var image: Image = Image("user-placeholder")
    @Published var posterId: String = ""
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var images: [Data] = []
    @Published var imageArray: [ListingImage] = []
    @Published var uploadingImages = false
    
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
    
    /*
     * this function takes in a document reference and uploads a bunch of
     * images asyncronously, so we can await all of the image uploads at once
     */
    
    //TODO: performace improvement?
    private func uploadImages(listing_ref: DocumentReference) async -> [String] {
        await withTaskGroup(of: (Int, URL?).self) { group in
            for (i, image) in self.images.enumerated(){
                group.addTask {
                    let image_name = "\(listing_ref.documentID)-\(i).jpeg"
                    let img_ref = Ref.FIREBASE_STORAGE.reference().child(image_name)
                    guard let metadata = try? await img_ref.putDataAsync(
                        image,
                        metadata: StorageMetadata(dictionary: ["contentType": "image/jpeg"])
                    ) else {
                        return (i, nil)
                    }
                    guard let img_path = metadata.path else { return (i, nil) }
                    return (i, try? await Ref.FIREBASE_STORAGE.reference(withPath: img_path).downloadURL())
                    
                        
                }
            }
            var urls = [Int:String]()
            for await (i, img_url) in group {
                if img_url == nil {
                    continue
                }
                urls[i]  = img_url!.absoluteString
            }
            return urls.sorted(by: {a,b in a.0 < b.0}).map({ (_, url) in url})
        }
    }
    
    
    private func getListingsFromDB(onSuccess: @escaping(_ listings: [Listing]) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        Ref.FIRESTORE_COLLECTION_LISTINGS
            .order(by: "datePosted", descending: true)
            .getDocuments { (snapshot, error) in
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
    
    func addListing(posterId: String, onSuccess: @escaping(_ listing: Listing) -> Void, onError: @escaping(_ errorMessage: String) -> Void) async {
        
        
        
        let listing = Listing(posterId: posterId, title: self.title, description: self.description, datePosted: Date().timeIntervalSince1970)
        
        guard let dict = try? listing.toDictionary() else { return }
        
        //adding listing without the image to the firebase
        let listing_ref = Ref.FIRESTORE_COLLECTION_LISTINGS.addDocument(data: dict){ error in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
        }
        if self.images.count == 0 {
            onSuccess(listing)
            return
        }
        
        
        let url_array = await uploadImages(listing_ref: listing_ref)
        
        do{
            try await listing_ref.updateData( [
                "imageUrls": url_array,
                "listingId": listing_ref.documentID,
            ] )
        }
        catch { 
            onError("listing update error, hanging images")
            return
        }
        onSuccess(listing)
    }
}
