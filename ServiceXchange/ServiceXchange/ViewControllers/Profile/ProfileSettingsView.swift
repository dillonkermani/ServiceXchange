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
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
            VStack {
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
                .buttonStyle(labelFormatt())
                
                //delete your account
                NavigationLink(destination: ProfileViewDeleteAccount(), label: {
                    Label("Delete Account", systemImage: "trash")
                        .frame(width: 300, height: 30)
                })
                .buttonStyle(labelFormatt())
                
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
                .buttonStyle(labelFormatt())
                //change password
                //delete your account
                NavigationLink(destination: ProfileViewChangePassword(), label: {
                    Label("Change Password", systemImage: "key.horizontal")
                        .frame(width: 300, height: 30)
                })
                .buttonStyle(labelFormatt())
                //Saved Listings
                NavigationLink(destination: EmptyView(), label: {
                    Label("Saved Listings", systemImage: "bookmark")
                        .frame(width: 300, height: 30)
                })
                .buttonStyle(labelFormatt())
            } //VStack
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 17)).bold()
                        }.foregroundColor(.black)
                    }
                }//ToolBarItem
            }//toolbar
    }
}


struct labelFormatt: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
        .padding()
        .fontWeight(.semibold)
        .background(.white)
        .foregroundColor(.black)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.black, lineWidth: 2)
        )
    }

}


struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
            .environmentObject(UserViewModel())
            .environmentObject(SessionStore())
    }
}
