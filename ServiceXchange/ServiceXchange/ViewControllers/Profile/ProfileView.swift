//
//  ProfileView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//


// ok problemo --> every time that you leave the profile view and come back a new userVM object is
//being created
// solution --> find somwhere else to initialize and most likely has to be passed along to almost all views
//or where is there a view where it can stay???


import SwiftUI
import FirebaseCore
import FirebaseFirestore
import Kingfisher


struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode // Allows us to dismiss views.
    @EnvironmentObject var session: SessionStore // Stores user's login status.
    
    
    //@ObservedObject var userVM = UserViewModel()
    @EnvironmentObject var userVM: UserViewModel
    
    // @State var controls = CreateProfileControls() //some control variables for the image picker now given for
    
    var body: some View {
        VStack {
            
//            KFImage(URL(string : userVM.localProfileImageUrl))
//                .frame(width: 250.0, height: 250.0, alignment: .center)
            
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
        }.onAppear{
            
            //initailize the local variables if you have not already
            if (userVM.initialized == false){
                print("profile view, Initial image url: ", userVM.localProfileImageUrl)
                print( "initailized var >>> : ", userVM.initialized )
                userVM.updateLocalUserVariables(user: session.userSession!)
                print( "after updated initailized var >>> : ", userVM.initialized )
            }
        }
        
        
    }
}
