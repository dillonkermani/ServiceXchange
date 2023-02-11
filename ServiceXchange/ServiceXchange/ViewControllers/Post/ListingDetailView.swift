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
    

    @ObservedObject var viewModel: ListingDetailViewModel
    
    init(listing: Listing) {
        viewModel = ListingDetailViewModel(listing: listing)
        
    }
    func listing_images(urls: [String]) -> some View {
        return AsyncImage(url: URL(string: urls[0])) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width:  .infinity, height: 400)
            case .success(let image):
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 400 )
                    .background(
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .brightness(0.3)
                            .blur(radius: 15)
                    )
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
    }
    var body: some View {
            VStack {
                listing_images(urls: [viewModel.listing.cardImageUrl])
                Text(viewModel.listing.title)
                    .font(.system(size: 40)).bold()
                    .frame(alignment: .leading)
                
                Text(viewModel.poster.firstName)
                Text(viewModel.listing.description)
                    .font(.system(size: 25))
                    .padding()
                
            }.frame(width: .infinity, alignment: .leading)
    }
}



let sample_listing = Listing(
    listingId: "poopylolpoop",
    posterId: "7syxwXFCwYh6HevOXCD9oTJJV7n1",
    cardImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/servicexchange-5c2cb.appspot.com/o/RuQF2I7AUVhKqprlGy3s.jpeg?alt=media&token=9a8cc66d-ce14-49ca-a7b1-45ed851987ed",
    title: "Sample Post",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    datePosted: 0.0,
    categories: ["piss", "shid"]
)

struct ListingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ListingDetailView(listing: sample_listing)
    }
}
