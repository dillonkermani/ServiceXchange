//
//  ListingDetailView.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/8/23.
//

import SwiftUI
import FirebaseStorage

enum ActiveAlert {
    case reportListing, deleteListing
}

struct ListingDetailViewControls {
    var deleteClicked = false
    var showAlert = false
    var activeAlert: ActiveAlert = .reportListing
    var savePressed = false
    var sendMessagePressed = false
}


struct ListingDetailView : View {
    
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var session: SessionStore
    
    
    @State private var report_clicked = false
    @State var rating = 0.0
    
    @State var controls = ListingDetailViewControls()
    
    @StateObject var listingVM = ListingDetailViewModel()

    //to be passed to the profile view
//    @State private var userToPass : User = User(
//        userId: "",
//        firstName: "",
//        lastName: "",
//        email: "",
//        isServiceProvider: false,
//        listings: []
//    )
    @State private var thisUser : Bool = false
    
    
    var listing: Listing
    
    var body: some View {
        VStack {
            ScrollView {
                URLCarouselView(urls: listing.imageUrls)
                    .frame(maxHeight: 400)
                
                ListingTitleBar()
                
                PosterDataView()
                    .padding(.bottom, 25)
                
                DetailsView()
                Spacer()
                
                if session.isLoggedIn && session.userSession != nil {
                    if session.userSession!.userId != listing.posterId {
                        RequestServiceButton(fromUser: session.userSession!, toUser: listingVM.poster)
                    }
                }
                
                Spacer()
                ListingCategoriesView()
            }
        }.navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 17)).bold()
                        }.foregroundColor(.black)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    ListingMenuButton()
                }
            }
            .gesture(DragGesture()
                .onEnded { value in
                    let direction = detectDirection(value: value)
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
    
    private func ListingTitleBar() -> some View {
        return HStack {
            Text(listing.title)
                .font(.system(size: 36)).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            Spacer()
            Button {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                controls.savePressed.toggle()
            } label: {
                Image(systemName: controls.savePressed ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 27))
                    .foregroundColor(controls.savePressed ? .blue : .black)
            }.padding(.trailing, 30)
        }
        .onAppear {
            Task{
                await listingVM.getListingPoster(posterId: listing.posterId)
                //userToPass = listingVM.poster
            }
        }
    }//listing Title bar
    
            private func ListingMenuButton() -> some View {
                Menu {
                    NavigationLink(destination: ChatsView(), label: {
                        Label("Send Message", systemImage: "paperplane")
                    })
                    Button(role: .none, action: {
                        controls.activeAlert = .reportListing
                        controls.showAlert.toggle()
                        
                    }, label: {
                        Label("Report", systemImage: "flag.fill")
                            .foregroundColor(.red)
                    })
                    if session.userSession?.userId == listing.posterId { // If currently signed in user is the poster of the Listing
                        Button(role: .none, action: {
                            controls.activeAlert = .deleteListing
                            controls.showAlert.toggle()
                        }, label: {
                            Label("Delete", systemImage: "trash")
                                .foregroundColor(.black)
                        })
                    }
                }
            label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .padding()
            }
            }
            
            private func DetailsView() -> some View {
                return VStack {
                    HStack {
                        Text("Details:")
                            .font(.system(size: 18)).bold()
                            .padding(.bottom, 1)
                        Spacer()
                    }
                    HStack {
                        Text(listing.description)
                            .font(.system(size: 20))
                        Spacer()
                    }
                    
                    Spacer()
                }.padding(25)
            }
            
            private func ListingCategoriesView() -> some View {
                return VStack {
                    if listing.categories != nil {
                        HStack {
                            Text("Categories:")
                                .font(.system(size: 17)).bold()
                            Spacer()
                        }.padding(25)
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(listing.categories ?? [], id: \.self) { category in
                                    FilterTag(filterData: CategoryCell(title: category, imageName: "square.grid.2x2", isSelected: true))
                                    
                                }
                                Spacer()
                            }
                        }
                        .scrollIndicators(.never)
                    }
                }
                
            }
            
            
            
            func PosterDataView() -> some View {
                
                return HStack {
                    NavigationLink(destination: ProfileProviderView(user : listingVM.poster, rating: rating)){
                        HStack{
                            if listingVM.poster.profileImageUrl == nil {
                                Image("blankprofile")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .overlay(RoundedRectangle(cornerRadius: 35)
                                        .stroke(Color(.label), lineWidth: 1)
                                    )
                                    .shadow(radius: 5)
                            } else {
                                UrlImage(url: listingVM.poster.profileImageUrl ?? "")
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .overlay(RoundedRectangle(cornerRadius: 35)
                                        .stroke(Color(.label), lineWidth: 1)
                                    )
                                    .shadow(radius: 5)
                            }
                            VStack(alignment: .leading) {
                                Text("\(listingVM.poster.firstName) \(listingVM.poster.lastName)")
                                    .padding(.horizontal, 5)
                                    .foregroundColor(.black)
                                    .font(.system(size: 20))
                                RatingView(rating: rating)
                                    .padding(.horizontal, 5)
                                
                            }
                        }.task {
                            self.rating = await getRating(userId: listing.posterId)
                            await self.listingVM.getListingPoster(posterId: listing.posterId)
                            //await userToPass = listingVM.poster
                        }
                    }.disabled(listingVM.loadingPoster)
                    Spacer()
                    
                }
                .frame(height: 50)
                .padding(.horizontal, 25)
            }
}


struct ListingDetailView_Previews: PreviewProvider {

    static var previews: some View {
        ListingDetailView(listing: Listing(listingId: "", posterId: "7syxwXFCwYh6HevOXCD9oTJJV7n1", imageUrls: [""], title: "title", description: "description", datePosted: 0, categories: []))
            .environmentObject(SessionStore())
    }
}
