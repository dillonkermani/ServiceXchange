//
//  HomeView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI

struct HomeView: View {
    
    //@EnvironmentObject var session: SessionStore
    
// Custom Search Bar() components
    private var listOfCountry = countryList
    private var listOfPosts = posts
    @State var searchText = ""

    
    
    var countries: [String] {
        let lcCountries = listOfCountry.map { $0.lowercased() }

        return searchText == "" ? lcCountries : lcCountries.filter {
            $0.contains(searchText.lowercased())
        }
    }
    
    // Custom Scroll Bar() components
    private var listOfTags = tags
    
        
    var body: some View {
        ZStack {
            
            NavigationStack {
                VStack {
                    ScrollView (.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(listOfPosts, id: \.self) { x in
                                Button(action: {print("You clicked")}){
                                    Text("\(x)")
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                        .frame(width: 90, height: 40)
                                        .background(.green)
                                        .cornerRadius(25)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 25)
//                                                .stroke(.black, lineWidth: 2)
//                                        )
                                }
                            }
                        }
                    }.padding([.leading, .trailing], 10)
                    
                    
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
                    }.navigationTitle("ServiceXchange")
                }
            }
            .searchable(text: $searchText)
            
            VStack {
                
                /*
                 if session.userSession != nil {
                 if session.isLoggedIn {
                 Text("Welcome, \(session.userSession!.firstName)")
                 }
                 } else {
                 Text("Not logged in")
                 }
                 */
                
                // Custom Search Bar()
                
                // Horizontally Scrollable Category Picker
                

                Spacer()

            }
            .padding()
        }
        .onAppear {
            print(listOfTags)
            print(listOfPosts)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
