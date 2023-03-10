//
//  MapView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        VStack(spacing: 15) {
            Text("Find Providers in Your Area")
                .font(.system(size: 20))
            Text("(Coming Soon!)")
                .font(.system(size: 15)).bold()
        }
        
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
