//
//  HomeView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        ZStack {
            VStack {
                Image("sxc_title")
                    .resizable()
                    .cornerRadius(40)
                    .scaledToFit()
                    .padding()
                
                if session.isLoggedIn {
                    Text("Logged In")
                } else {
                    Text("Not logged in")
                }
                
                // Custom Search Bar()
                
                // Horizontally Scrollable Category Picker
                
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
