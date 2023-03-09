//
//  ProfileProviderView.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 3/7/23.
//

import SwiftUI

struct ProfileProviderView: View {
    
    @Binding var user: User
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {

        let profileRadius: CGFloat = 125
        let arrowSize: CGFloat = 17
        
        ZStack{
            
            ProfileBackground(imageStr: user.descriptiveImageStr ?? "sunsetTest")
                .offset( y: Constants.screenHeight * -0.30)
            
            ProfileImage(imageStr: user.profileImageUrl ?? "blankprofile", diameter: profileRadius)
                .offset(y: Constants.screenHeight * -0.175)
            
            NavigationLink(destination: ChatsView(), label: {
                Image(systemName: "paperplane")
                    .font(.system(size: 35,
                                  weight: .regular,
                                  design: .default))
                    .foregroundColor(.black)
            })
            .padding(.bottom, Constants.screenHeight * 0.27)
            .padding(.leading, Constants.screenWidth * 0.7)
            
            if user.companyName == "" {
                Text(user.firstName + " " + user.firstName)
                    .font(.title2)
                    .offset(y: Constants.screenHeight * -0.06)
            }
            else {
                Text(user.companyName ?? "none")
                    .font(.title2)
                    .offset(y: Constants.screenHeight * -0.06)
            }
            
        }//ZStack
        .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(.system(size: arrowSize)).bold()
                        }.foregroundColor(.black)
                    }
                }//ToolBarItem
                
                
            }//toolbar
        
    }
}

