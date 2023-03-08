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
        
        let topPaddingBackground: CGFloat = -430
        let topPaddingProfile: CGFloat = -240
        let profileRadius: CGFloat = 125
        let arrowSize: CGFloat = 17
        
        ZStack{
            
            showBackGroundImage(imageStr: user.descriptiveImageStr ?? "sunsetTest")
                .padding(.top , topPaddingBackground)
            
            showProfileImage(imageStr: user.profileImageUrl ?? "blankprofile", diameter: profileRadius)
                .padding(.top, topPaddingProfile)
            
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
