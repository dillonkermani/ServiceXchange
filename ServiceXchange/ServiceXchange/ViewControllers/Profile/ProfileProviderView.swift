//
//  ProfileProviderView.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 3/7/23.
//

import SwiftUI

struct ProfileProviderView: View {
    
    var user: User
    let rating: Double
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var session: SessionStore

    
    var body: some View {

        let arrowSize: CGFloat = 17
        
        ZStack {
            ScrollView {
                
                VStack(spacing: 10) {
                    ProfileHeader()
                        .padding(.bottom, 50)
                    
                    Text(user.companyName?.isEmpty ?? true ? "No Company Name" : "\(user.companyName!)")
                        .font(.system(size: 30)).bold()
                    RatingView(rating: rating)
                    Text(user.bio?.isEmpty ?? true ? "No Company Description" : user.bio!)
                        .font(.system(size: 20))
                    
                    Text(user.primaryLocationServed?.isEmpty ?? true ? "No Primary Location Specified" : "Location: \(user.primaryLocationServed!)")
                        .font(.system(size: 17))

                    if session.userSession != nil {
                        if user.userId != session.userSession!.userId {
                            RequestServiceButton(fromUser: session.userSession!, toUser: user)
                        }
                    }
                    CalendarView(forUser: user.userId)
                        .frame(minHeight: 300)
                        .padding()
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

struct ProfileProvider_Previews: PreviewProvider {
    static var previews: some View {
        ProfileProviderView(user: User(userId: "7syxwXFCwYh6HevOXCD9oTJJV7n1", firstName: "Sam", lastName: "W", email: "fake@email.com", isServiceProvider: true), rating: 3.6)
            .environmentObject(SessionStore())
    }
}
