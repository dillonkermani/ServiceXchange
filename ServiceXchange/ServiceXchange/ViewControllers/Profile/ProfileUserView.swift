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
        
        
        
        let topPaddingBackground: CGFloat = -410
        let topPaddingProfile: CGFloat = -215
        let profileRadius: CGFloat = 125
        
        ZStack{
            showBackGroundImage(imageStr: userVM.localDescriptiveImageStr)
                .padding(.top , topPaddingBackground)
            
            showProfileImage(imageStr: userVM.localProfileImageUrl, diameter: profileRadius)
                .padding(.top, topPaddingProfile)
            
            
            
            NavigationLink(destination: ProfileSettingsView(), label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 35,
                                  weight: .regular,
                                  design: .default))
                    .foregroundColor(.black)
                    .frame(width: 47, height: 47)
                    .background(.white)
                    .cornerRadius(40)
            })
            

           
            
//            settingMenu()
//                .padding(.leading, 270)
//                .padding(.top, -350)
            
        }.navigationBarHidden(true)
            .onAppear{
                if (userVM.initialized == false && session.userSession != nil){
                    userVM.updateLocalUserVariables(user: session.userSession!)
                }//if uninitailized (this can get moved if we want info in other pages (maybe tabview icon?)
            }
        
    }
}


struct SheetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Button("Press to dismiss") {
            dismiss()
        }
        .font(.title)
        .padding()
        .background(.black)
    }
}


private func settingMenu() -> some View{
   
    return VStack {
        Menu {
            NavigationLink("Edit Profile Nav", destination: EditProfileView())
            Button("Edit Profile"){
                print("edit profile")
            }
        } label: {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 35,
                              weight: .regular,
                              design: .default))
                .foregroundColor(.black)
                .frame(width: 47, height: 47)
                .background(.white)
                .cornerRadius(40)
        } //label
        
        
    }//VStack
} //setting Menu 3

//params: image url string and the diameter of the circle
//returns circular profile image (either default or user profile image)
func showProfileImage(imageStr : String, diameter: CGFloat) -> some View {
    return VStack {
        
        if imageStr != "blankprofile"  && imageStr != ""{
            
            
            AsyncImage(url: URL(string:  imageStr)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: diameter, height: diameter , alignment: .center)
                    .clipShape(Circle())
            } placeholder: {
                ShimmerPlaceholderView(width: diameter, height: diameter, cornerRadius: 0, animating: false)
            }
            
        }
        else {
            let defaultImage = "blankprofile"
            Image(defaultImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: diameter, height: diameter, alignment: .center)
                .clipShape(Circle())
        }
    }
}//showProfileImage

//takes in an image string
//returns a 400 x 250 image (either a default or a user image)
func showBackGroundImage(imageStr : String) -> some View {
    let imHeight: CGFloat = 250
    let imWidth: CGFloat = 400
    
    return VStack {
        
        if imageStr == "" || imageStr == "sunsetTest"{
            Image("sunsetTest")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: imWidth, height: imHeight, alignment: .top)
                .clipShape(Rectangle())
        }
        else {
            
            AsyncImage(url: URL(string:  imageStr)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imWidth, height: imHeight )
                    .clipShape(Rectangle())
            } placeholder: {
                ShimmerPlaceholderView(width: imWidth, height: imHeight, cornerRadius: 0, animating: true)
            }
            

        }
    }
}//showDetailImage


struct ProfileUserView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUserView()
            .environmentObject(UserViewModel())
    }
}
