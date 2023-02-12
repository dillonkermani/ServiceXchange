//
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/10/23.
//
import SwiftUI
import FirebaseCore
import FirebaseFirestore

let skeleton_user = User(
    userId: "",
    firstName: "",
    lastName: "",
    email: "",
    isServiceProvider: false,
    listingIDs: [],
    profileImageUrl: ""
)

class ListingDetailViewModel: ObservableObject {
    @Published var poster: User = skeleton_user
    @Published var listing: Listing
    init(listing: Listing) {
        self.listing = listing
        let user_ref = Ref.FIRESTORE_DOCUMENT_USERID(userId: listing.posterId)
        user_ref.getDocument { (document, error) in
            if let dict = document?.data() {
                guard let user = try? User.init(fromDictionary: dict) else {
                    return
                }
                self.poster = user
            }
        }
    }
}
