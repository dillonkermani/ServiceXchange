//
//  ProfileSettingsView.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 2/13/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import Kingfisher

struct ProfileSettingsView: View {
        
    @EnvironmentObject var session: SessionStore

    
    @EnvironmentObject var userVM: UserViewModel
    
    @State var controls = CreateProfileControls()
    
    var body: some View {
            VStack{
                
                ShowProfileImage()
                
                HStack{

                    ScrollView {
                        ButtonStack()
                    }//scrollView
                }
            }

    }//body
    
    
    //returns a circular profile image
    private func ShowProfileImage() -> some View{
        
        return VStack {
            let image_url = userVM.localProfileImageUrl
            KFImage(URL(string:  image_url))
                .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250.0, height: 250.0, alignment: .center)
                    .clipShape(Circle())
        }
    }
    
    
    private func ButtonStack() -> some View {
        return VStack(spacing: 30) {
            //addProfilePhoto()
            // .padding(.bottom, 20)
            
            
            Spacer()
            
            //edit service provider profile button --> does this become a create listing once you have done it?
            NavigationLink(destination: EditProfileView(), label: {
                CustomProfileButtonView(title: "View Provider Account", foregroundColor: .white, backgroundColor: CustomColor.sxcgreen)
            })
            
            //saved listings --> goes to a page that has the saved listing posts
            NavigationLink(destination: SavedListingsView(), label: {
                CustomProfileButtonView(title: "Saved Listings", foregroundColor: .white, backgroundColor: .blue.opacity(0.3))
            })
            
            //to do -> clear local varibales on sign out
            Button {
                session.logout()
                controls.alertMessage = "Sucessfully Logged Out"
                controls.showAlert.toggle()
            } label: {
                CustomProfileButtonView(title: "Sign Out", foregroundColor: .red, backgroundColor: .gray.opacity(0.5))
                
            }
        }//button stack
    }
    
    
    private func CustomProfileButtonView(title: String, foregroundColor: Color, backgroundColor: Color) -> some View {
        return ZStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width / 1.3, height: 50)
                .shadow(radius: 5)
                .foregroundColor(backgroundColor)
            Text(title)
                .font(.system(size: 17)).bold()
                .foregroundColor(foregroundColor)
        }.cornerRadius(30)
    }

    
    
}
    
