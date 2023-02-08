//
//  ListingDetailView.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/8/23.
//

import SwiftUI
import Kingfisher
import FirebaseStorage

struct ListingDetailView : View {
    

    @State var poster: User
    @State var listing: Listing
    
    init(listing: Listing) {
        self.listing = listing
        let user_ref = Ref.FIRESTORE_DOCUMENT_USERID(userId: listing.posterId)
        var poster: User?
        user_ref.getDocument { (document, error) in
            if let dict = document?.data() {
                guard let user = try? User.init(fromDictionary: dict) else {
                    return
                }
                poster = user;
                return
            }
        }
        self.poster = poster!
    }
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: listing.cardImageUrl)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable()
                                     .aspectRatio(contentMode: .fit)
                                     .frame(maxWidth: 300, maxHeight: 100)
                            case .failure:
                                Image(systemName: "photo")
                            @unknown default:
                                // Since the AsyncImagePhase enum isn't frozen,
                                // we need to add this currently unused fallback
                                // to handle any new cases that might be added
                                // in the future:
                                EmptyView()
                            }
                        }
            Text($listing.title)
            Text($poster.firstName)
        }
    }
}



let sample_listing = Listing(
    listingId: "poopylolpoop",
    posterId: "7syxwXFCwYh6HevOXCD9oTJJV7n1 ",
    cardImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/servicexchange-5c2cb.appspot.com/o/RuQF2I7AUVhKqprlGy3s.jpeg?alt=media&token=9a8cc66d-ce14-49ca-a7b1-45ed851987ed",
    title: "Sample Post",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    datePosted: 0.0,
    categories: ["piss", "shid"]
)

struct ListingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ListingDetailView(listing: sample_listing)
    }
}
