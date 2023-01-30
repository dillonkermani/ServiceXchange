//
//  ProfileView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var session = SessionStore()

    
    var body: some View {
        Text("ProfileView")
        
        Button {
            session.logout()
        } label: {
            Text("Logout")
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
