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
    @Published var pickerSelection = 0
    var searchText: String = ""
    var selectedCategories: [CategoryCell] = []
    
    func categoriesDidChange() {
        var listings: [Listing] = []
        
        if selectedCategories.isEmpty {
            return
        } else {
            for listing in self.allListings {
                if listing.categories != nil {
                    for catagory in selectedCategories {
                        if listing.categories!.contains(catagory.title) {
                            listings.append(listing)
                            break
                        }
                    }
                    
                }
            }
            self.listings = listings
        }
    }
    
    private func searchMatch(listing: Listing, search: String) -> Bool {
        if search.isEmpty {
            return true
        }
        if listing.title.isEmpty {
            return false
        }
        return listing.title.lowercased().contains(search.lowercased())
    }
    
    func applyFilters() {
        let catagoryNames = self.selectedCategories.map({c in return c.title})
        self.listings = self.allListings.filter({listing in
            let matchesCategories = {
                if catagoryNames.isEmpty {
                    return true
                }
                for c in catagoryNames {
                    guard let listingCatagories = listing.categories else {
                        return catagoryNames.isEmpty
                    }
                    if listingCatagories.contains(c) {
                        return true
                    }
                }
                return false
            }() // imidiadly call closure to get result
            let matchesSearch = searchMatch(listing: listing, search: self.searchText)
            return matchesCategories && matchesSearch
        })
    }
    
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
    
    func loadListings(forUser: User) {
        if forUser.listings != nil {
            if !forUser.listings!.isEmpty {
                for listingId in forUser.listings! {
                    Ref.FIRESTORE_COLLECTION_LISTINGS.document(listingId)
                        .getDocument { (document, error) in
                            if let document = document, document.exists {
                                let dict = document.data()
                                guard let decodedListing = try? Listing.init(fromDictionary: dict!) else { return }
                                self.listings.append(decodedListing)
                            } else {
                                print("Document does not exist")
                            }
                        }
                }
            }
        }
    }
    
    func loadListings() -> Void {
        self.isLoading = true
        getListingsFromDB(onSuccess: {listings in
            self.allListings = listings
            self.applyFilters()
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
