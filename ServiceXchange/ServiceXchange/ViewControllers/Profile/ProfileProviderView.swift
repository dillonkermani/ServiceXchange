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
        
        //let topPaddingBackground: CGFloat = -430
        //let topPaddingProfile: CGFloat = -240
        let profileRadius: CGFloat = 125
        let arrowSize: CGFloat = 17
        
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        ZStack{
            
            showBackGroundImage(imageStr: user.descriptiveImageStr ?? "sunsetTest")
                //.padding(.top , topPaddingBackground)
                .offset( y: screenHeight * -0.30)
            
            showProfileImage(imageStr: user.profileImageUrl ?? "blankprofile", diameter: profileRadius)
                //.padding(.top, topPaddingProfile)
                .offset(y: screenHeight * -0.175)
            
            
            NavigationLink(destination: ChatsView(), label: {
                Image(systemName: "paperplane")
                    .font(.system(size: 35,
                                  weight: .regular,
                                  design: .default))
                    .foregroundColor(.black)
                    
            })
            .padding(.bottom, screenHeight * 0.27)
            .padding(.leading, screenWidth * 0.7)
            
            if user.companyName == "" {
                Text(user.firstName + " " + user.firstName)
                    .font(.title2)
                    .offset(y: screenHeight * -0.06)
            }
            else {
                Text(user.companyName ?? "none")
                    .font(.title2)
                    .offset(y: screenHeight * -0.06)
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

//struct ProfileProviderView_Previews: PreviewProvider {
//    static var previews: some View {
//        var my_user : User = init(userId: n, firstName: "cole", lastName: "j", email: "c@g", isServiceProvider: false, listingIDs: [], phone: "1234")
//        ProfileProviderView(my_user)
//    }
//}
