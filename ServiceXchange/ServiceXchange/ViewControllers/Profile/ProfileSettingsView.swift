//
//  ProfileSettingsView.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 3/7/23.
//

import SwiftUI

struct ProfileSettingsView: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var userVM: UserViewModel
    
    
    var body: some View {
        
        ZStack{
            
//            Image(systemName: "gearshape.2")
//                .padding(.top, 100)
//                //.frame(width: 25, height: 25)
//
            VStack {
                //Image(systemName: "gearshape.2")
                NavigationStack{
                    
                    Image(systemName: "wrench.and.screwdriver")
                        .font(.system(size: 90))
                        .fontWeight(.light)
                        .padding(.top, -100)
                        .padding(.bottom, 60)
                        //.frame(width: 50, height: 50)
                    
                    //edit your profile
                    NavigationLink(destination: EditProfileView(), label: {
                        Label("Edit Profile", systemImage: "pencil")
                            .frame(width: 300, height: 30)
                    })
                    .padding()
                    .fontWeight(.semibold)
                    .background(.white)
                    .foregroundColor(.black)
                    .border(Color.black, width: 3)
                    
                    
                    //delete your account
                    NavigationLink(destination: ProfileViewTest(), label: {
                        Label("Delete Account", systemImage: "trash")
                            .frame(width: 300, height: 30)
                    })
                    .padding()
                    .background(.white)
                    .foregroundColor(.black)
                    .border(Color.black, width: 1)
                    
                    //sign out
                    Button(action: {
                        session.isLoggedIn = false
                        session.logout()
                        //clear local user variables
                        userVM.clearLocalUserVariables()
                    }, label: {
                        Label("Sign Out", systemImage: "figure.walk.motion")
                            .frame(width: 300, height: 30)
                        
                    })
                    .padding()
                    .background(.white)
                    .foregroundColor(.black)
                    .border(Color.black, width: 1)
                    
                    
                    //change password
                    //delete your account
                    NavigationLink(destination: ProfileViewTest(), label: {
                        Label("Change Password", systemImage: "key.horizontal")
                            .frame(width: 300, height: 30)
                    })
                    .padding()
                    .background(.white)
                    .foregroundColor(.black)
                    .border(Color.black, width: 1)
                    
                    
                    //Saved Listings
                    NavigationLink(destination: SavedListingsView(), label: {
                        Label("Saved Listings", systemImage: "bookmark")
                            .frame(width: 300, height: 30)
                    })
                    .padding()
                    .background(.white)
                    .foregroundColor(.black)
                    .border(Color.black, width: 1)
                }//NavStack
            } //VStack
        }//ZStack
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
            .environmentObject(UserViewModel())
            .environmentObject(SessionStore())
    }
}
