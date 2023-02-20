//
//  CreateListingViewModel.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/17/23.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

struct ListingImage: Identifiable, Equatable {
    var id: UUID
    var image: Image
    var data: Data
}

class CreateListingViewModel : ObservableObject {
    @Published var listingId: String = ""
    @Published var posterId: String = ""
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var images: [ListingImage] = []
    @Published var pickedImageData = Data()
    @Published var pickedImage = Image("")
    @Published var uploadingImages = false
    let maxImageCount = 8
    @Published var categories: [CategoryCell] = []
    
    /*
     * this function takes in a document reference and uploads a bunch of
     * images asyncronously, so we can await all of the image uploads at once
     */
    
    // Posts Listing to Firestore
    func postListing(posterId: String, onSuccess: @escaping(_ listing: Listing) -> Void, onError: @escaping(_ errorMessage: String) -> Void) async {
        
        var categoryNames: [String] = []
        for category in categories {
            categoryNames.append(category.title)
        }
        
        // Init Listing Model to be pushed to Firestore.
        let listing = Listing(posterId: posterId, title: self.title, description: self.description, datePosted: Date().timeIntervalSince1970, categories: categoryNames)
        
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
            self.listingId = listing_ref.documentID
        }
        catch {
            onError("listing update error, hanging images")
            return
        }
        onSuccess(listing)
    }
    
    //TODO: performace improvement?
    private func uploadImages(listing_ref: DocumentReference) async -> [String] {
        await withTaskGroup(of: (Int, URL?).self) { group in
            for (i, image) in self.images.enumerated(){
                group.addTask {
                    let image_name = "\(listing_ref.documentID)-\(i).jpeg"
                    let img_ref = Ref.FIREBASE_STORAGE.reference().child(image_name)
                    guard let metadata = try? await img_ref.putDataAsync(
                        image.data,
                        metadata: StorageMetadata(dictionary: ["contentType": "image/jpeg", "customMetadata": ["poster": self.posterId]])
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
    
    func isPostable() -> Bool {
        return !(self.title.isEmpty || self.description.isEmpty || self.categories.isEmpty || self.images.isEmpty)
    }
    func maxImageCountReached() -> Bool {
        return self.images.count > self.maxImageCount
    }
    
    func addListingImage() {
        images.append(ListingImage(id: UUID(), image: self.pickedImage, data: self.pickedImageData))
        return
    }
    
    
    
}
