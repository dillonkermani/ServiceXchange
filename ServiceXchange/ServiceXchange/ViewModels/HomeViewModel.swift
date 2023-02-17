//
//  HomeViewModel.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/17/23.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published var allListings: [Listing] = []
    @Published var isLoading = false
    @Published var loadErrorMsg = ""
    
    private func getListingsFromDB(
        onSuccess: @escaping(_ listings: [Listing]) -> Void,
        onError: @escaping(_ errorMessage: String) -> Void
    ) -> Void {
        
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
    
    func loadListings() -> Void {
        self.isLoading = true
        getListingsFromDB(onSuccess: {listings in
            self.allListings = listings
            self.isLoading = false
        }, onError: {errorMessage in
            self.loadErrorMsg = errorMessage
            self.isLoading = false
        })
    }
    
}
