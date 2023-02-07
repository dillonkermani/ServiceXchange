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
    var searchText = ""
}

struct HomeView: View {
    
    @ObservedObject var listingVM = ListingViewModel()
    
    @State var controls = HomeViewControls()
    

    init() {
        listingVM.loadListings()
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack {
                        HStack {
                            Image("sxc_title_transparent")
                                .resizable()
                                .frame(width: 300, height: 95)
                                .padding()
                            Spacer()
                        }
                        CategoryPicker()
                            .searchable(text: $controls.searchText)
                        ListingsGrid()
                    }
                }
            }.navigationBarHidden(true)
            
        }
    }
    
    
    
    
    fileprivate func CategoryPicker() -> some View {
        return ScrollView (.horizontal, showsIndicators: false) {
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
    }
    
    fileprivate func ListingsGrid() -> some View {
        return ScrollView(.vertical) {
            if !listingVM.isLoading {
                Group {
                    HStack {
                        Text("All Services")
                            .font(.system(size: 25)).bold()
                        Spacer()
                    }.padding(.vertical, 10)
                    .padding(.top, 5)
                    .padding(.leading, 25)
                    
                    LazyVGrid(columns: controls.gridItems, alignment: .center, spacing: 15) {
                        if listingVM.allListings.isEmpty || listingVM.isLoading {
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
            } else {
                Text(listingVM.loadErrorMsg)
            }
        }
    }
    
    func ListingCardView(listing: Listing) -> some View {
        return ZStack(alignment: .bottom) {
            KFImage(URL(string: listing.cardImageUrl))
                .placeholder({
                    ShimmerPlaceholderView(width: controls.width, height: controls.height, cornerRadius: 0, animating: true)
                })
                .basicKFModifiers(cgSize: CGSize(width: controls.height, height: controls.width))
                .aspectRatio(contentMode: .fill)
                .frame(width: controls.width, height: controls.height)
                .clipped()
            
            
            cardGradient()
                .rotationEffect(.degrees(180))
                .frame(width: controls.width, height: controls.height)
             
            
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
