//
//  ContentView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/30/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore

    
    var body: some View {
        ZStack {
            TabView()
        }.onAppear{session.listenAuthenticationState()}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
