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
    @Binding var categories: [CategoryCell]
    
    var body: some View {
        VStack {
            FilterBar()
                .environmentObject(filterModel)
            Spacer()
            List {
                ForEach(filterModel.categories.indices, id: \.self) { index in
                    let catagory = self.categories[index]
                    FilterTag(filterData: catagory)
                        .onTapGesture {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            filterModel.toggleFilter(at: index)
                        }
                }.onAppear {
                    var i = 0
                    for filterCategory in filterModel.categories {
                        for category in categories {
                            if category.title == filterCategory.title {
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
                        .padding(15)
                    Spacer()
                }
                .background(CustomColor.sxcgreen)
                .foregroundColor(.black)
                .cornerRadius(17)
                .overlay(
                    RoundedRectangle(cornerRadius: 17)
                        .stroke(.black, lineWidth: 2)
                )
                .padding(40)
                
            }
        }
        .padding()
    }
    
    func saveButtonPressed() {
        var updatedCategories: [CategoryCell] = []
        
        for category in filterModel.categories {
            if category.isSelected {
                updatedCategories.append(category)
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
    @Published var categories = Constants.categoryList
    
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
        ZStack {
            Rectangle()
                .frame(width: 80, height: 60)
                .foregroundColor(filterData.isSelected ? CustomColor.sxcgreen : .white)
                .cornerRadius(17)
                .overlay(
                    RoundedRectangle(cornerRadius: 17)
                        .stroke(.black, lineWidth: 1)
                )
                        
            VStack {
                Image(systemName: filterData.imageName)
                    .font(.system(size: 23))
                    .padding(.bottom, 3)
                Text(filterData.title)
                    .font(.system(size: 10)).bold()
            }
            .foregroundColor(.black)
        }
        .padding(1)
            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
    }
}

struct SearchFilterView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

