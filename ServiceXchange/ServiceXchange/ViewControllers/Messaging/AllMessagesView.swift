//
//  MessagesView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct ChatUser {
    let uid, email, profileImageUrl: String
}

struct MessagesControls {
    var showNewMessageScreen = false
    var shouldShowLogOutOptions = false

}

struct MessagesView: View {
    
    @State var controls = MessagesControls()
    @EnvironmentObject var session: SessionStore // Contains currently signed in user's info.

    
    var body: some View {
        NavigationView {
            
            VStack {
                CustomNavBar()
                MessagesList()
            }
            .overlay(
                newMessageButton(), alignment: .bottom)
            .navigationBarHidden(true)
        }
    }
    
    private func CustomNavBar() -> some View {
        HStack(spacing: 16) {
            
            UrlImage(url: session.userSession?.profileImageUrl ?? "")
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipped()
                .cornerRadius(44)
                .overlay(RoundedRectangle(cornerRadius: 44)
                    .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(session.userSession?.firstName ?? "")
                    .font(.system(size: 24, weight: .bold))
                
                HStack {
                    Circle()
                        .foregroundColor(.green)
                        .frame(width: 14, height: 14)
                    Text("online")
                        .font(.system(size: 12))
                        .foregroundColor(Color(.lightGray))
                }
                
            }
            
            Spacer()
            Button {
                controls.shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.label))
            }
        }
        .padding()
        .actionSheet(isPresented: $controls.shouldShowLogOutOptions) {
            .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("handle sign out")
                }),
                    .cancel()
            ])
        }
    }
    
    private func MessagesList() -> some View {
        ScrollView {
            ForEach(0..<10, id: \.self) { num in
                VStack {
                    NavigationLink(destination: MessageDetailView()) {
                        
                        HStack(spacing: 16) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 32))
                                .padding(8)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label), lineWidth: 1)
                                )
                            
                            
                            VStack(alignment: .leading) {
                                Text("Username")
                                    .font(.system(size: 16, weight: .bold))
                                Text("Message sent to user")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                            }
                            Spacer()
                            
                            Text("2d")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        
                    }.foregroundColor(.black)
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
                
            }.padding(.vertical)
            .padding(.bottom, 50)
        }
    }
    
    
    
    private func newMessageButton() -> some View {
        Button {
            controls.showNewMessageScreen.toggle()
        } label: {
            HStack {
                Spacer()
                Text("+  New Message")
                    .font(.system(size: 16, weight: .bold))
                    .padding(15)
                Spacer()
            }
            .background(CustomColor.sxcgreen)
            .foregroundColor(.black)
            .cornerRadius(17)
            .overlay(
                RoundedRectangle(cornerRadius: 17)
                    .stroke(.black, lineWidth: 2)
            )
            .padding(15)
        }
        .sheet(isPresented: $controls.showNewMessageScreen) {
            CreateNewMessageView()
        }
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
