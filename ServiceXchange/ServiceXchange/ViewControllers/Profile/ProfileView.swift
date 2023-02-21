//
//  ProfileView.swift
//  ServiceXchange
//
//  Created by Colton Jeffrey on 1/25/23.
//



import SwiftUI
import FirebaseCore
import FirebaseFirestore
import Kingfisher


struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode // Allows us to dismiss views.
    @EnvironmentObject var session: SessionStore // Stores user's login status.
    
    @EnvironmentObject var userVM: UserViewModel //stores user variables localy and finds
    
    
    var body: some View {
        VStack {
            SettingNavButton()

        }.onAppear{
            
            //initailize the local user variables if you have not already
            if (userVM.initialized == false){
                userVM.updateLocalUserVariables(user: session.userSession!)
            }//if uninitailized (this can get moved if we want info in other pages (maybe tabview icon?))
        }//onAppear
        
        
    }
    
    
    private func SettingNavButton() -> some View {
        return VStack{
            NavigationLink(destination: ProfileSettingsView(), label: {
                Image(systemName: "gear")
                
                    .font(.system(size: 35,
                                  weight: .regular,
                                  design: .default))
                    .foregroundColor(.black)
                    .frame(width: 50, height: 50)
                    .background(CustomColor.sxcgreen)
                    .cornerRadius(40)
            })
        }
        
    }//setting nav button
    
}
