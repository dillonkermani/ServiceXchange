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
            ZStack {
                ProfileBackground(imageStr: userVM.localDescriptiveImageStr)
                    .offset(y: Constants.screenHeight * -0.27)
                
                ProfileImage(imageStr: userVM.localProfileImageUrl, diameter: 125)
                    .offset(y: Constants.screenHeight * -0.15)
                
                NavigationLink(destination: ProfileSettingsView(), label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                        .frame(width: 45, height: 45)
                        .background(.white)
                        .cornerRadius(5)
                })
                .padding(.bottom, Constants.screenHeight * 0.69)
                .padding(.leading, Constants.screenWidth * 0.73)
                
                Text(userVM.localCompanyName)
                    .font(.title2)
                    .offset(y: Constants.screenHeight * -0.05)
                    
                Text("\(session.userSession!.firstName) \(session.userSession!.lastName)")
            }
        }.navigationBarHidden(true)
            .onAppear{
                //initialize local variables if they have not been initialized
                //already
                if (userVM.initialized == false && session.userSession != nil){
                    userVM.updateLocalUserVariables(user: session.userSession!)
                }//if uninitailized
            }
    }
}


//params: image url string and the diameter of the circle
//returns circular profile image (either default or user profile image)
func ProfileImage(imageStr : String, diameter: CGFloat) -> some View {
    return VStack {
        if imageStr != "blankprofile"  && imageStr != "" {
            AsyncImage(url: URL(string:  imageStr)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: diameter, height: diameter , alignment: .center)
                    .clipShape(Circle())
            } placeholder: {
                ShimmerPlaceholderView(width: diameter, height: diameter, cornerRadius: diameter/2, animating: false)
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
}

//takes in an image string
//returns a 400 x 250 image (either a default or a user image)
func ProfileBackground(imageStr : String) -> some View {
    return VStack {
        if imageStr == "" || imageStr == "sunsetTest"{
            Image("sunsetTest")
                .resizable()
                .frame(width: Constants.screenWidth - 20, height: Constants.screenHeight * 0.25, alignment: .top)
                .clipShape(Rectangle())
                .cornerRadius(20)
        }
        else {
            AsyncImage(url: URL(string:  imageStr)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Constants.screenWidth - 20, height: Constants.screenHeight * 0.25, alignment: .top)
                    .clipShape(Rectangle())
                    .cornerRadius(20)
            } placeholder: {
                ShimmerPlaceholderView(width: Constants.screenWidth - 20, height: Constants.screenHeight * 0.25, cornerRadius: 17, animating: false)
            }
        }
    }
}//showDetailImage


struct ProfileUserView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileUserView()
            .environmentObject(UserViewModel())
            .environmentObject(SessionStore())
    }
}
