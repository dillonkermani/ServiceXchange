//
//  HomeViewModel.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/17/23.
//

import Foundation

// Main Functions: 1) Loads all Listings from Firestore. 2) Performs search by title or category.
class HomeViewModel: ObservableObject {
    
    @Published var allListings: [Listing] = [] // All Listings Cached in ViewModel
    @Published var listings: [Listing] = [] // Only the listings to Display to user
    @Published var isLoading = false
    @Published var loadErrorMsg = ""
    var searchText: String = ""
    
    func searchTextDidChange() {
        if searchText.isEmpty {
            self.listings = allListings
            return
        }
        isLoading = true
        self.searchListings(text: searchText) { (listings) in
            self.isLoading = false
            self.listings = listings
        }
    }
    
    // private func for searchTextDidChange()
    private func searchListings(text: String, onSuccess: @escaping(_ listings: [Listing]) -> Void) {
        var listings = [Listing]()
        for listing in self.allListings {
            if listing.title.lowercased().contains(text.lowercased()) {
                listings.append(listing)
                continue
            }
            for category in listing.categories ?? [""] {
                if category.lowercased().contains(text.lowercased()) {
                    listings.append(listing)
                    continue
                }
            }
        }
        onSuccess(listings)
    }
    
    func loadListings() -> Void {
        self.isLoading = true
        getListingsFromDB(onSuccess: {listings in
            self.allListings = listings
            self.listings = listings
            self.isLoading = false
        }, onError: {errorMessage in
            self.loadErrorMsg = errorMessage
            self.isLoading = false
        })
    }
    
    // private func for loadListings()
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
    
    
    
}
