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
    @EnvironmentObject var session: SessionStore

    
    var body: some View {

        let profileRadius: CGFloat = 125
        let arrowSize: CGFloat = 17
        
        ZStack {
            ScrollView {
                
                VStack(spacing: 60) {
                    ProfileHeader()
                        .padding(.bottom, 20)
                    
                    Text(user.companyName?.isEmpty ?? true ? "No Company Name" : "\(user.companyName!)")
                        .font(.system(size: 30)).bold()
                    
                    Text(user.bio?.isEmpty ?? true ? "No Company Description" : user.bio!)
                        .font(.system(size: 20))
                    
                    Text(user.primaryLocationServed?.isEmpty ?? true ? "No Primary Location Specified" : "Location: \(user.primaryLocationServed!)")
                        .font(.system(size: 17))
                    
                    if session.userSession != nil {
                        if user.userId != session.userSession!.userId {
                            RequestServiceButton(fromUser: session.userSession!, toUser: user)
                        }
                    }
                }
                
            }
        }
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
            .gesture(DragGesture()
                .onEnded { value in
                    let direction = detectDirection(value: value)
                    if direction == .left {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            )
    }
    
    private func ProfileHeader() -> some View {
        return ZStack {
            ProfileBackground(imageStr: user.descriptiveImageStr ?? "sunsetTest")
            
            ProfileImage(imageStr: user.profileImageUrl ?? "blankprofile", diameter: 125)
                .offset(y: 80)
            
        }
    }
}

