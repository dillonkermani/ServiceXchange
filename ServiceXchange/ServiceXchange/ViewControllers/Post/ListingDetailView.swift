//
//  ListingDetailView.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/8/23.
//

import SwiftUI
import Kingfisher
import FirebaseStorage

enum ActiveAlert {
    case reportListing, deleteListing
}

struct listingDetailViewControls {
    var deleteClicked = false
    var showAlert = false
    var activeAlert: ActiveAlert = .reportListing

}

struct ListingDetailView : View {

    @Environment(\.presentationMode) var presentationMode

    @State private var report_clicked = false
    @State var rating = 0.0

    @State var controls = listingDetailViewControls()

    @ObservedObject var listingVM = ListingDetailViewModel()

    var listing: Listing

    var body: some View {
        VStack {
            ScrollView {
                URLCarouselView(urls: listing.imageUrls)
                    .frame(maxHeight: 400)
                Text(listing.title)
                    .font(.system(size: 36)).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()

                PosterDataView()
                Text(listing.description)
                    .font(.system(size: 20))
                    .padding()
            }
        }.gesture(DragGesture()
            .onEnded { value in
              let direction = self.detectDirection(value: value)
              if direction == .left {
                  presentationMode.wrappedValue.dismiss()
              }
            }
        )
        .alert(isPresented: $controls.showAlert) {
            switch controls.activeAlert {
            case .reportListing:
                return Alert(title: Text("Report Listing?"),
                             message: Text("Not Implemented"),
                             dismissButton: Alert.Button.default(
                                 Text("OK"), action: {

                                 }
                             )
                         )
            case .deleteListing:
                return Alert(title: Text("Delete Listing?"), message: Text("Warning: This action cannot be undone."), primaryButton: .destructive(Text("Delete")) {

                    listingVM.deleteListing(listing: listing)
                    presentationMode.wrappedValue.dismiss()


                }, secondaryButton: .cancel())

            }

        }
        .onAppear {
            Task{
                await listingVM.getListingPoster(posterId: listing.posterId)
            }
        }
    }

    enum SwipeHVDirection: String {
        case left, right, up, down, none
    }
    private func detectDirection(value: DragGesture.Value) -> SwipeHVDirection {
        if value.startLocation.x < value.location.x - 24 {
                return .left
              }
              if value.startLocation.x > value.location.x + 24 {
                return .right
              }
              if value.startLocation.y < value.location.y - 24 {
                return .down
              }
              if value.startLocation.y > value.location.y + 24 {
                return .up
              }
        return .none
    }

    func PosterDataView() -> some View {

        return HStack {
            //TODO: make Profile View take in a userid instead of nothing (profile view my be the wrong view to link)
            NavigationLink(destination: ProfileView()){
                HStack{
                    UrlImage(url: listingVM.poster.profileImageUrl ?? "")
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text("\(listingVM.poster.firstName) \(listingVM.poster.lastName)")
                            .padding(.horizontal, 0)
                        RatingView(rating: rating)
                            .padding(.horizontal, 5)
                            .task {
                                self.rating = await getRating(userId: listing.posterId)
                            }

                    }
                }.task {
                    await self.listingVM.getListingPoster(posterId: listing.posterId)
                }
            }
            Spacer()
            Menu {
                NavigationLink(destination: MessagesView(), label: {
                    Label("Send Message", systemImage: "envelope")
                })
                Button(role: .destructive, action: {
                    controls.activeAlert = .reportListing
                    controls.showAlert.toggle()

                }, label: {
                    Label("Report", systemImage: "flag.fill")
                        .foregroundColor(Color.red)
                })
                if true {//session.userSession?.userId == listing.posterId { // If currently signed in user is the poster of the Listing
                    Button(role: .destructive, action: {
                        controls.activeAlert = .deleteListing
                        controls.showAlert.toggle()
                    }, label: {
                        Label("Delete", systemImage: "trash")
                            .foregroundColor(.black)
                    })

                }

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


}


struct ListingDetailView_Previews: PreviewProvider {

    static var previews: some View {
        ListingDetailView(listing: Listing(listingId: "", posterId: "7syxwXFCwYh6HevOXCD9oTJJV7n1", imageUrls: [""], title: "title", description: "description", datePosted: 0, categories: []))
    }
}
