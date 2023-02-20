//
//  SelectCategoriesView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/19/23.
//

import SwiftUI

struct SelectCategoriesView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var filterModel = FilterModel()
    @State var listingId: String = ""
    @Binding var categories: [String]
    
    var body: some View {
        VStack {
            FilterBar()
                .environmentObject(filterModel)
            Spacer()
            List {
                ForEach(0..<filterModel.categories.count) { index in
                    FilterTag(filterData: filterModel.categories[index])
                        .onTapGesture {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            filterModel.toggleFilter(at: index)
                        }
                }.onAppear {
                    var i = 0
                    for filterCategory in filterModel.categories {
                        for category in categories {
                            if category == filterCategory.title {
                                filterModel.toggleFilter(at: i)
                            }
                        }
                        i += 1
                    }
                }
            }
            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                
                // TODO: Save category updates
                saveButtonPressed()
                
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Text("Save")
                        .font(.system(size: 17))
                        .padding(10)
                    Spacer()
                }
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                .padding(40)
            }
        }
        .padding()
    }
    
    func saveButtonPressed() {
        var updatedCategories: [String] = []
        
        for category in filterModel.categories {
            if category.isSelected {
                updatedCategories.append(category.title)
            }
        }
        
        categories = updatedCategories
    }
}

struct FilterBar: View {
    // 1
    @EnvironmentObject var filterModel: FilterModel
    
    // 2
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            // 3
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(filterModel.selection) { item in
                        FilterTag(filterData: item)
                    }
                }
            }
            Spacer()
            Button(action: { filterModel.clearSelection() }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color.black.opacity(0.6))
            }
        }
        .padding(6)
        .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color.gray.opacity(0.5)))
    }
}

class FilterModel: NSObject, ObservableObject {
    
    // 1. normally you would get this data from a remote service, so factor that in if you use
    // this in your own projects. If this data is not static, consider making it @Published
    // so that any changes to it will get reflected by the UI
    @Published var categories = [
        CategoryCell(title: "Jobs", imageName: "suitcase.fill"),
        CategoryCell(title: "Food", imageName: "fork.knife"),
        CategoryCell(title: "Clothing", imageName: "tshirt"),
        CategoryCell(title: "Electronics", imageName: "laptopcomputer.and.iphone"),
        CategoryCell(title: "Education", imageName: "brain.head.profile"),
        CategoryCell(title: "Entertainment", imageName: "ticket"),
        CategoryCell(title: "Health", imageName: "heart"),
        CategoryCell(title: "Automotive", imageName: "car"),
        CategoryCell(title: "Home Decor", imageName: "house"),
        CategoryCell(title: "Pet Services", imageName: "comb"),
        CategoryCell(title: "Travel", imageName: "airplane.departure")
    ]
    
    // 2. these are the FilterData that have been selected using the toggleFilter(at:)
    // function.
    @Published var selection = [CategoryCell]()
    
    // 3. toggles the selection of the filter at the given index
    func toggleFilter(at index: Int) {
        guard index >= 0 && index < categories.count else { return }
        categories[index].isSelected.toggle()
        refreshSelection()
    }
    
    // 4. clears the selected items
    func clearSelection() {
        for index in 0..<categories.count {
            categories[index].isSelected = false
        }
        refreshSelection()
    }
    
    // 5. remakes the published selection list
    func refreshSelection() {
        let result = categories.filter{ $0.isSelected }
        withAnimation {
            selection = result
        }
    }
}



struct FilterTag: View {
    // 1
    var filterData: CategoryCell
    
    // 2
    var body: some View {
        Label(filterData.title, systemImage: filterData.imageName)
            .font(.caption)
            .padding(4)
            .foregroundColor(filterData.isSelected ? .black : .white)
            .background(
                RoundedRectangle(cornerRadius: 8)  // 3
                    .foregroundColor(filterData.isSelected ?  CustomColor.sxcgreen : Color.gray.opacity(0.8))
            )
            // 4
            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
    }
}

struct SearchFilterView_Previews: PreviewProvider {
    static var previews: some View {
        //SelectCategoriesView(listingId: "")
        EmptyView()
    }
}

