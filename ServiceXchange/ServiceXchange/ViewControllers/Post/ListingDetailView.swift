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
    
    @State private var report_clicked = false
    
    @ObservedObject var viewModel: ListingDetailViewModel
    
    init(listing: Listing) {
        viewModel = ListingDetailViewModel(listing: listing)
        
    }
    func display_rating(rating: Double) -> some View {
        let ones = Int(rating)
        let tens = Int(rating * 10) % 10
        return VStack(alignment: .leading){
            HStack {
                ForEach(1..<6) {i in
                    if rating >= Double(i){
                        Image(systemName: "star.fill")
                            .frame(width: 10, height: 10)
                            .foregroundColor(CustomColor.sxcgreen)
                    }
                    // if its x.2 and i + 1 < x ex: 3.3 i=3 yes 4.3 i=3 no
                    else if tens > 2 && rating + 1 > Double(i) {
                        Image(systemName: "star.leadinghalf.fill")
                            .frame(width: 10, height: 10)
                            .foregroundColor(CustomColor.sxcgreen)
                    }
                    else {
                        Image(systemName: "star")
                            .frame(width: 10, height: 10)
                            .foregroundColor(CustomColor.sxcgreen)

                    }
                }
                
                Text("(\(ones).\(tens))")
            }
        }
    }
    
    //TODO: fetch actual poster rating from firestore
    func poster_data(poster: User, listing_rating: Double) -> some View {

        return HStack {
            //TODO: make Profile View take in a userid instead of nothing
            NavigationLink(destination: ProfileView()){
                HStack{
                    KFImage(URL(string: poster.profileImageUrl ?? "https://firebasestorage.googleapis.com:443/v0/b/servicexchange-5c2cb.appspot.com/o/RuQF2I7AUVhKqprlGy3s.jpeg?alt=media&token=9a8cc66d-ce14-49ca-a7b1-45ed851987ed")) //TODO: create default image for users with no pfp
                        .placeholder({
                            ShimmerPlaceholderView(width: 64, height: 64, cornerRadius: 0, animating: true)
                                .cornerRadius(100)
                        })
                    
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .scaledToFit()
                        .cornerRadius(.infinity)
                        .clipped(antialiased: true)
                    VStack(alignment: .leading) {
                        Text("\(poster.firstName) \(poster.lastName)")
                            .padding(.horizontal, 0)
                        display_rating(rating: listing_rating)
                            .padding(.horizontal, 5)
                        
                    }
                }
            }
            Spacer()
            Menu {
                NavigationLink(destination: MessagesView(), label: {
                    Label("Send Message", systemImage: "envelope")
                })
                Button(role: .destructive, action: {report_clicked = true}, label: {
                    Label("Report", systemImage: "flag.fill")
                        .foregroundColor(Color.red)
                })
                
            }
            label: {
                VStack {
                    ForEach(0..<3) { _ in
                        Rectangle()
                            .cornerRadius(.infinity)
                            .frame(width: 5, height: 5)
                            .foregroundColor(.black) //TODO: make a default text color, give this that color
                    }
                }
                .padding()

            }
        }
        .frame(height: 50)
        .padding(.horizontal, 20)
    }
    
    var body: some View {
        VStack {
            ScrollView {
                URLCarouselView(urls: viewModel.listing.imageUrls)
                    .frame(maxHeight: 400)
                Text(viewModel.listing.title)
                    .font(.system(size: 36)).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                poster_data(poster: viewModel.poster, listing_rating: 3.5)
                Text(viewModel.listing.description)
                    .font(.system(size: 20))
                    .padding()
                
            }
        }
    }
}



let sample_listing = Listing(
    listingId: "poopylolpoop",
    posterId: "7syxwXFCwYh6HevOXCD9oTJJV7n1",
    imageUrls: ["https://firebasestorage.googleapis.com:443/v0/b/servicexchange-5c2cb.appspot.com/o/RuQF2I7AUVhKqprlGy3s.jpeg?alt=media&token=9a8cc66d-ce14-49ca-a7b1-45ed851987ed"],
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
