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
    var selectedCategory = ""
    var searchText = ""
    var showSearchBar = false
}

struct HomeView: View {
    
    @ObservedObject var homeVM = HomeViewModel()
    
    @State var controls = HomeViewControls()
    

    init() {
        homeVM.loadListings()
    }
    
    var body: some View {
        VStack {
            NavigationStack {
                ScrollView {
                    VStack {
                        HStack {
                            HeaderLabel()
                            Spacer()
                            searchButton()
                        }.padding(.bottom, 25)
                        if controls.showSearchBar {
                            SearchBar(initialText: "Search services", text: $homeVM.searchText, onSearchButtonChanged: homeVM.searchTextDidChange)
                                .padding(.horizontal, 5)
                        }
                        CategoryPicker()
                        ListingsGrid()
                    }.padding([.top, .bottom], 65)
                }
            }.toolbar(.hidden)
        }
    }
    
    private func HeaderLabel() -> some View {
        return HStack {
            Image("sxc_title_transparent")
                .resizable()
                .frame(width: 275, height: 90)
                .padding(.leading, 15)
            Spacer()
        }
    }
    
    private func searchButton() -> some View {
        return  HStack(spacing: 20) {
            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                withAnimation {
                    controls.showSearchBar.toggle()
                }
            }) {
                Image(systemName: controls.showSearchBar ? "chevron.up" : "magnifyingglass")
                    .imageScale(.large)
                    .foregroundColor(.black)
                    .padding(25)
            }
        }
    }
    
    private func CategoryPicker() -> some View {
        return ScrollView (.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(controls.categoryList, id: \.self) { category in
                    Button(action: {
                        controls.selectedCategory = category}) {
                        
                            ZStack {
                                Rectangle()
                                    .frame(width: 105, height: 40)
                                    .foregroundColor(CustomColor.sxcgreen)
                                    .cornerRadius(20)

                                Text("\(category)")
                                    .foregroundColor(.white)
                                    .padding()
                                    .font(.system(size: 15)).bold()

                            }.cornerRadius(20)

                    }
                }
            }
        }.padding([.leading], 20)
            .padding(.top, 25)
    }
    
    private func ListingsGrid() -> some View {
        return VStack {
                HStack {
                    Text("All Services")
                        .font(.system(size: 25)).bold()
                    Spacer()
                }.padding(.vertical, 10)
                .padding(.top, 5)
                .padding(.leading, 25)
                
                LazyVGrid(columns: controls.gridItems, alignment: .center, spacing: 15) {
                    if homeVM.allListings.isEmpty || homeVM.isLoading {
                        ForEach(0..<10) { _ in
                            ShimmerPlaceholderView(width: controls.width, height: controls.height, cornerRadius: 5, animating: true)
                        }
                    } else {
                        ForEach(homeVM.listings, id: \.listingId) { listing in
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
