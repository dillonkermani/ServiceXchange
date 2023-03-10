//
//  ProfileUserView.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 3/6/23.
//

import SwiftUI

//if you are signed into the app and looking at your own profile
struct ProfileUserView: View {
    
    //pass in user information throught the user environment
    @EnvironmentObject var userVM: UserViewModel
    
    //pass in userSession through sessionStore (not sure if this will presist)
    @EnvironmentObject var session: SessionStore
    
    //to show the settings sheet
    @State private var showingSettingSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 10) {
                    ProfileHeader()
                        .padding(.bottom, 50)
                    
                    Text(userVM.localCompanyName.isEmpty ? "No Company Name" : "\(userVM.localCompanyName)")
                        .font(.system(size: 30)).bold()
                    
                    Text(userVM.localBio.isEmpty ? "No Company Description" : userVM.localBio)
                        .font(.system(size: 20))
                    
                    Text(userVM.localPrimaryLocationServed.isEmpty ? "No Primary Location Specified" : "Location: \(userVM.localPrimaryLocationServed)")
                        .font(.system(size: 15))
                    Rectangle()
                        .frame(height: 2)
                        .padding()
                    CalendarEditView(forUser: userVM.localUserId)
                }
                
            }
        }.toolbar(.hidden)
            .onAppear{
                //initialize local variables if they have not been initialized
                //already
                if (userVM.initialized == false && session.userSession != nil){
                    userVM.updateLocalUserVariables(user: session.userSession!)
                }//if uninitailized
            }
    }
    
    private func ProfileHeader() -> some View {
        return ZStack {
            ProfileBackground(imageStr: userVM.localDescriptiveImageStr)
            
            ProfileImage(imageStr: userVM.localProfileImageUrl, diameter: 125)
                .offset(y: 80)
            
            NavigationLink(destination: ProfileSettingsView(), label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                    .frame(width: 45, height: 45)
                    .background(.white)
                    .cornerRadius(5)
            })
            .offset(x: Constants.screenWidth / 2.7, y: -45)
        }
    }
}


struct ProfileUserView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUserView()
            .environmentObject(UserViewModel())
            .environmentObject(SessionStore())
    }
}
