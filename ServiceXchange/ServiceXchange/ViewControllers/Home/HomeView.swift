//
//  HomeView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI

struct HomeViewControls {
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    var width = (UIScreen.main.bounds.width * 0.43)
    var height = (UIScreen.main.bounds.width * 0.43)
    var categoryList: [CategoryCell] = Constants.categoryList
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
                    LazyVStack(pinnedViews:[.sectionHeaders]) {
                        
                        HStack {
                            HeaderLabel()
                            Spacer()
                            searchButton()
                        }.padding(.bottom, 25)
                        if controls.showSearchBar {
                            SearchBar(initialText: "Search services", text: $homeVM.searchText, onSearchButtonChanged: homeVM.searchTextDidChange)
                                .padding(.horizontal, 5)
                        }
                        
                        
                        Section(header:
                                    CategoryPicker()
                                
                        
                        ) {
                            ListingsGrid()
                        }
                    }
                        
                }
                .padding(.top, 0.1)
            }.toolbar(.hidden)
        }
    }
    
    private func HeaderLabel() -> some View {
        return HStack {
            Image("sxc_title_transparent")
                .resizable()
                .frame(width: 275, height: 87)
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
                    .padding()
            }
        }
    }
    
    private func CategoryPicker() -> some View {
        return ScrollView (.horizontal, showsIndicators: false) {
            HStack() {
                ForEach(controls.categoryList, id: \.self) { category in

                    FilterTag(filterData: category)
                        .onTapGesture {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            controls.categoryList[category.index!].isSelected.toggle()
                            
                            var selectedCategories: [CategoryCell] = []
                            for category in controls.categoryList {
                                if category.isSelected {
                                    selectedCategories.append(category)
                                }
                            }
                            if selectedCategories.count == 0 {
                                selectedCategories = controls.categoryList
                            }
                            homeVM.selectedCategories = selectedCategories
                            homeVM.categoriesDidChange()
                            
                     }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 3)
        .padding(.trailing, 15)
            .background(Color.white)
            .offset(x: 15)
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
                            LoadingView()
                                .cornerRadius(17)
                                .frame(width:controls.width, height: controls.height)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 17)
                                        .stroke(.black, lineWidth: 1)
                                )
                        }
                    } else {
                        ForEach(homeVM.listings, id: \.listingId) { listing in
                            NavigationLink(destination: ListingDetailView(listing: listing)) {
                                ListingCardView(listing: listing)
                            }
                            .simultaneousGesture(TapGesture().onEnded{
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
