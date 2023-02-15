//
//  ListingDetailView.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/8/23.
//

import SwiftUI
import Kingfisher
import FirebaseStorage

struct listingDetailViewControls {
    var reportClicked = false
    var deleteClicked = false
    var showAlert = false
    var alertMessage = ""
    var alertButtonText = ""
}

struct ListingDetailView : View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var session: SessionStore

    
    @State var controls = listingDetailViewControls()
    
    @ObservedObject var listingVM = ListingViewModel()
    
    @State var listing: Listing
    
    var body: some View {
        VStack {
            ScrollView {
                URLCarouselView(urls: listing.imageUrls)
                    .frame(maxHeight: 400)
                Text(listing.title)
                    .font(.system(size: 36)).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                PosterDataView(poster: listingVM.poster, listing_rating: 3.5)
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

            if controls.deleteClicked {
                return Alert(title: Text("Delete Listing?"), message: Text("This action is permanent and cannot be undone."), primaryButton: .destructive(Text("Delete")) {
                       
                    listingVM.deleteListing()
                    presentationMode.wrappedValue.dismiss()
                    
                }, secondaryButton: .cancel())
            } else {
                
                return Alert(title: Text(controls.alertMessage),
                      message: Text(""),
                      dismissButton: Alert.Button.default(
                        Text(controls.alertButtonText), action: {
                            
                            
                        }
                      )
                )
            }
        }
        .onAppear {
            listingVM.getListingPoster(listing: listing)
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
    func PosterDataView(poster: User, listing_rating: Double) -> some View {

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
                Button(role: .destructive, action: {controls.reportClicked = true}, label: {
                    Label("Report", systemImage: "flag.fill")
                        .foregroundColor(Color.red)
                })
                if session.userSession?.userId == listing.posterId { // If currently signed in user is the poster of the Listing
                    Button(role: .destructive, action: {
                        controls.alertMessage = "Delete Listing?"
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
        ListingDetailView(listing: Listing(listingId: "", posterId: "", imageUrls: [], title: "", description: "", datePosted: 0, categories: []))
    }
}
