//
//  ProfileViewTest.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 2/21/23.
//

import SwiftUI




struct ProfileViewTest: View {
    
    @ObservedObject var loginVM = LoginViewModel()
    
    @State var thisUserProfile = false
   // var user: User
    
    
    var body: some View {
        
        VStack {
            
            //imageOverlayTop(thisUserProfile: thisUserProfile)
            signInFields()

        }
    }
    
    
    private func signInFields() -> some View {
        return ZStack {
            VStack {
                HStack {
                    Text("Sign In")
                        .font(.largeTitle)
                        .padding([.top, .bottom], 75)
                }
                underlinedTextField(title: "Email", text: $loginVM.email, width: 310, height: 40, color: loginVM.email.isEmpty ? .black : CustomColor.sxcgreen)
                    .keyboardType(.emailAddress)
                passwordTextField(title: "Password", text: $loginVM.password, width: 310, height: 40, color: loginVM.password.isEmpty ? .black : CustomColor.sxcgreen)
                    .padding(.bottom, 40)
                
                Button {
                    print("Forgot Password Pressed")
                } label: {
                    Text("Forgot Username or Password?")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                        .underline()
                }

                
                Spacer()
                
            }
            
        }
    } //
    
    
    
    
    //returns the detail image bahind profile and either setting or message icon
    func imageOverlayTop(thisUserProfile : Bool) -> some View {
        return  ZStack{
             showDetailImage()
                 .padding(.top, -450)
             showProfileImage()
                 .padding(.top, -260)
            
            
            if thisUserProfile {
                settingMenu()
                     .padding(.leading, 270)
                     .padding(.top, -400)
            }
            else {
                messageNavButton()
                    .padding(.leading, 270)
                    .padding(.top, -400)
            }
        }
      
    }
    
    
    func messageNavButton() -> some View {
        return VStack {
            //changethis later so that it navigates straight to
            //a message with that person
            NavigationLink(destination: MessagesView(), label: {
                Image(systemName: "paperplane")
                    .font(.system(size: 35,
                                  weight: .semibold,
                                  design: .default))
                    .foregroundColor(.black)
                    .frame(width: 47, height: 47)
                    .background(.clear)
                    .cornerRadius(40)
            })
        }
    }
    
    //make this a button and make it spin and drop down a menu
    //replace the settiung view with just this menu
    //change these things to navigation links -> that go to the appropriate pages
    func settingMenu() -> some View {
        return VStack {
            Menu {
                Button("Edit Profile", action: order)
                Button("Change Password", action: order)
                Button("Saved Listings", action: order)
                Button("History", action: order)
                Button("sign out", action: order)
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 35,
                                  weight: .regular,
                                  design: .default))
                    .foregroundColor(.black)
                    .frame(width: 47, height: 47)
                    .background(.white)
                    .cornerRadius(40)
            }
        }
        
    }
    
    func order() {}
    
    func showProfileImage() -> some View {
        return VStack {
            Image("blankprofile")
                .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 125.0, height: 125.0, alignment: .center)
                    .clipShape(Circle())
        }
    }
    
    func showDetailImage() -> some View {
        return VStack {
          Image("sunsetTest")
                .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400.0, height: 250.0, alignment: .top)
                    .clipShape(Rectangle())
        }
    }
    

    
    
}

struct ProfileViewTest_Previews: PreviewProvider {
    static var previews: some View {
        ProfileViewTest()
    }
}
