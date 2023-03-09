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
        
        
        
//        let topPaddingBackground: CGFloat = -410
//        let topPaddingProfile: CGFloat = -215
//        let profileRadius: CGFloat = 125
//        let topPaddingGear: CGFloat = -330
//        let leadingPaddingGear: CGFloat  = 280
        let gearSize: CGFloat = 35
        let gearWidth: CGFloat = 47
//
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        NavigationStack {
            
            ZStack {
                
                showBackGroundImage(imageStr: userVM.localDescriptiveImageStr)
                    //.padding(.top, screenHeight * 0.1)
                    //.padding(.bottom, screenHeight * 0.55)
                    //.padding(.horizontal, 10)
                    .offset( y: screenHeight * -0.27)
                
                
                showProfileImage(imageStr: userVM.localProfileImageUrl, diameter: 125)
                    .offset(y: screenHeight * -0.15)
                //.padding(.bottom, screenHeight * 0.43)
                
                
                NavigationLink(destination: ProfileSettingsView(), label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: gearSize,
                                      weight: .regular,
                                      design: .default))
                        .foregroundColor(.black)
                        .frame(width: gearWidth, height: gearWidth)
                        .background(.white)
                        .cornerRadius(gearWidth)
                })
                .padding(.bottom, screenHeight * 0.70)
                .padding(.leading, screenWidth * 0.7)
                
                
                Text(userVM.localCompanyName)
                    .font(.title2)
                    .offset(y: screenHeight * -0.05)
                    //.offset(x: screenWidth * -0.35)
                    //.padding(.trailing, screenWidth * 0.45)
                    //.padding(.bottom, screenHeight * 0.20)
                
                Text("\" \(userVM.localBio) \"")
                    //.padding(.bottom, screenHeight * 0.05)
                
                
            }
    
            //Text("company Name")
                
           
            
            
           /*
        ZStack{
            
            showBackGroundImage(imageStr: userVM.localDescriptiveImageStr)
                .padding(.top , topPaddingBackground)
            
            showProfileImage(imageStr: userVM.localProfileImageUrl, diameter: profileRadius)
                .padding(.top, topPaddingProfile)
            
            
            
            NavigationLink(destination: ProfileSettingsView(), label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: gearSize,
                                  weight: .regular,
                                  design: .default))
                    .foregroundColor(.black)
                    .frame(width: gearWidth, height: gearWidth)
                    .background(.white)
                    .cornerRadius(gearWidth)
            })
            .padding(.top, topPaddingGear)
            .padding(.leading, leadingPaddingGear)
          
        }
          */
            
    }//Navigation Stack
        .navigationBarHidden(true)
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
func showProfileImage(imageStr : String, diameter: CGFloat) -> some View {
    return VStack {
        
        if imageStr != "blankprofile"  && imageStr != "" {
            
            
            AsyncImage(url: URL(string:  imageStr)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: diameter, height: diameter , alignment: .center)
                    .clipShape(Circle())
            } placeholder: {
                //ShimmerPlaceholderView(width: diameter, height: diameter, cornerRadius: 0, animating: false)
                LoadingView()
            }
            
        }
        else {
            let defaultImage = "blankprofile"
            Image(defaultImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
            //UIScreen.main.bounds.width /1.2
                .frame(width: diameter, height: diameter, alignment: .center)
                .clipShape(Circle())
        }
    }
}//showProfileImage

//takes in an image string
//returns a 400 x 250 image (either a default or a user image)
func showBackGroundImage(imageStr : String) -> some View {
 
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    return VStack {
        
        if imageStr == "" || imageStr == "sunsetTest"{
            Image("sunsetTest")
                .resizable()
                //.aspectRatio(contentMode: .fill)
                .frame(width: screenWidth - 20, height: screenHeight * 0.25, alignment: .top)
                .clipShape(Rectangle())
                .cornerRadius(20)
            
        }
        else {
            
            AsyncImage(url: URL(string:  imageStr)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: screenWidth - 20, height: screenHeight * 0.25, alignment: .top)
                    //.frame(width: imWidth, height: imHeight )
                    .clipShape(Rectangle())
                    .cornerRadius(20)
            } placeholder: {
                LoadingView()
                    //.frame(width: imWidth, height: imHeight )
                    
                //ShimmerPlaceholderView(width: imWidth, height: imHeight, cornerRadius: 0, animating: false)
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
