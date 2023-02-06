//
//  HomeView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI
import Kingfisher

struct HomeViewControls {
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    var width = (UIScreen.main.bounds.width * 0.43)
    var height = (UIScreen.main.bounds.width * 0.43)
    var categoryList = ["Category1", "Category2", "Category3", "Category4", "Category5"]
}

struct HomeView: View {
    
    //@EnvironmentObject var session: SessionStore
    
// Custom Search Bar() components
    @State var searchText = ""
    
    @ObservedObject var listingVM = ListingViewModel()
    
    @State var controls = HomeViewControls()
    
    
    

    
    // Custom Scroll Bar() components
    
     
    init() {
        listingVM.loadListings()
    }
    
    var body: some View {
        ZStack {
            
            
            
            NavigationStack {
                VStack {
                    
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(controls.categoryList, id: \.self) { x in
                                Button(action: {print("You clicked")}){
                                    Text("\(x)")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                        .frame(width: 90, height: 40)
                                        .background(.green)
                                        .cornerRadius(25)
                                }
                            }
                        }
                    }.padding([.leading, .trailing], 10)
                    
                    ScrollView(.vertical) {
                        if !listingVM.isLoading {
                            
                            AllListings()
                            
                        } else {
                            Text(listingVM.loadErrorMsg)
                        }
                    }
                    
                    
                    
                    /*
                    List {
                        ForEach(0..<4) {_ in
                            HStack() {
                                AsyncImage(url: URL(string: "https://www.shutterstock.com/shutterstock/photos/764462584/display_1500/stock-vector-dice-icon-iage-764462584.jpg")) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .aspectRatio(contentMode: .fit)
                                AsyncImage(url: URL(string: "https://www.shutterstock.com/shutterstock/photos/764462584/display_1500/stock-vector-dice-icon-iage-764462584.jpg")) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .aspectRatio(contentMode: .fit)
                            }
                        }
                    }
                     */
                    
                    
                }
            }.navigationTitle("ServiceXchange")
            .searchable(text: $searchText)
            
        }
    }
    
    fileprivate func AllListings() -> some View {
        Group {
            HStack {
                Text("Listings")
                Spacer()
            }.padding(.vertical, 10)
            .padding(.top, 5)
            .padding(.leading, 20)
            
            LazyVGrid(columns: controls.gridItems, alignment: .center, spacing: 15) {
                if listingVM.allListings.isEmpty {
                    ForEach(0..<10) { _ in
                        ShimmerPlaceholderView(width: controls.width, height: controls.height, cornerRadius: 5, animating: false)
                    }
                } else {
                    ForEach(listingVM.allListings, id: \.listingId) { listing in
                        NavigationLink(destination: ListingDetailView(listing: listing)) {
                            ListingCardView(listing: listing)
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        })
                    }
                            
                }
            }.padding(.horizontal, 10)
        }
    }
    
    func ListingCardView(listing: Listing) -> some View {
        return ZStack(alignment: .bottom) {
            KFImage(URL(string: listing.cardImageUrl))
                .placeholder({
                    ShimmerPlaceholderView(width: controls.width, height: controls.height, cornerRadius: 0, animating: true)
                })
                .frame(width: controls.width, height: controls.height)
                .clipped()
            
            /*
            cardGradient()
                .rotationEffect(.degrees(180))
                .frame(width: controls.width, height: controls.height)
             */
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(listing.title )
                        .foregroundColor(.white)
                        .lineLimit(1)
                }.padding(10)
                Spacer()
            }
        }
        .frame(width: controls.width, height: controls.height)
        .cornerRadius(5)
    }
    
    func ListingDetailView(listing: Listing) -> some View {
        return ZStack {
            Text("Not implemented")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
