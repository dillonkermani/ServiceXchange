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
                NavigationView {
                    List {
                        ForEach(countries, id: \.self) { country in
                            HStack {
                                Text(country.capitalized)
                                Spacer()
                                Image(systemName: "figure.walk")
                                    .foregroundColor(Color.blue)
                            }
                            .padding()
                        }
                    }
                    .searchable(text: $searchText)
                    .navigationTitle("ServiceXchange")
                }

                // Horizontally Scrollable Category Picker
                
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(0..<10) {
                            Text("Item \($0)")
                                .foregroundColor(.white)
                                .font(.title)
                                .frame(width: 100, height: 40)
                                .background(.green)
                                .cornerRadius(25)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(.black, lineWidth: 2)
                                )
                        }
                    }
                }
                

                // Load all listing thumbnails


                Spacer()

            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
