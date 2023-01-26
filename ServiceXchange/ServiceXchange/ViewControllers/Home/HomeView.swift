//
//  HomeView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            VStack {
                Image("sxc_title")
                    .resizable()
                    .cornerRadius(40)
                    .scaledToFit()
                    .padding()
                
                // Custom Search Bar()
                
                // Horizontally Scrollable Category Picker
                
                // Load all listing thumbnails
                
                Spacer()
                    
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            //.background(.white)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
