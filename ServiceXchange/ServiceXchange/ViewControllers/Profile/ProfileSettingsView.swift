//
//  ProfileSettingsView.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 2/13/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import Kingfisher

struct ProfileSettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode // Allows us to dismiss views.
    @EnvironmentObject var session: SessionStore // Stores user's login status.
    
    //session.refreshUser()
    
  
    var body: some View {
        
        
        
        if session.userSession != nil {
            let profileImageStr = session.userSession?.profileImageUrl ?? "nil"
            if profileImageStr != "nil" {
                KFImage(URL(string: profileImageStr))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250.0, height: 250.0, alignment: .center)
                    .clipShape(Circle())
            }
            else {
                Image("blankprofile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250.0, height: 250.0, alignment: .center)
                    .clipShape(Circle())
            }
            
            
            
            /*
            if profileURL == "nil" {
                KFImage(profileURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250.0, height: 250.0, alignment: .center)
                    .clipShape(Circle())
            }
            else {
                Image("blankprofile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250.0, height: 250.0, alignment: .center)
                    .clipShape(Circle())
            }
            */
        }
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
    }
}
