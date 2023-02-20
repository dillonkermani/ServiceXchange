//
//  ProfileView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//





import SwiftUI
import FirebaseCore
import FirebaseFirestore
import Kingfisher


struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode // Allows us to dismiss views.
    @EnvironmentObject var session: SessionStore // Stores user's login status.
    
    
    @ObservedObject var userVM = UserViewModel()
    
    
    // @State var controls = CreateProfileControls() //some control variables for the image picker now given for
    
    var body: some View {
        VStack {
            
//            KFImage(URL(string : userVM.localProfileImageUrl))
//                .frame(width: 250.0, height: 250.0, alignment: .center)
            
            NavigationLink(destination: ProfileSettingsView(userVM : userVM), label: {
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
            
            userVM.updateLocalUserVariables(user: session.userSession!)
        }
        
        
    }
}
