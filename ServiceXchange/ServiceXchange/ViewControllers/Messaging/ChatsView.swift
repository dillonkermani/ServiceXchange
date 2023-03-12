//
//  ChatsView.swift
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

struct ChatsView: View {
    
    @State var controls = MessagesControls()
    @EnvironmentObject var session: SessionStore // Contains currently signed in user's info.
    
    @ObservedObject var chatVM = ChatViewModel()
    
    @ObservedObject var dateFormatter = CustomDateFormatter()

    var body: some View {
        NavigationView {
            
            VStack {
                CustomNavBar()
                if session.userSession != nil {
                    if session.userSession!.chats != nil {
                        if !session.userSession!.chats!.isEmpty {
                            AllChatsList()
                        }
                    }
                } else {
                    Spacer()
                    Text("No Chats")
                    Spacer()
                }
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            // Check if user has any chats before trying to load chat data.
            if session.userSession!.chats != nil {
                if !session.userSession!.chats!.isEmpty {
                    chatVM.loadChatDataIfNeeded(forUser: session.userSession!)
                }
            }
        }
    }
    
    private func CustomNavBar() -> some View {
        HStack(spacing: 16) {
            if session.userSession!.profileImageUrl == nil {
                Image("blankprofile")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipped()
                    .cornerRadius(44)
                    .overlay(RoundedRectangle(cornerRadius: 44)
                        .stroke(Color(.label), lineWidth: 1)
                    )
                    .shadow(radius: 5)
            } else {
                UrlImage(url: session.userSession!.profileImageUrl!)
                    .scaledToFill()
                    .frame(width: 44, height: 44)
                    .clipped()
                    .cornerRadius(44)
                    .overlay(RoundedRectangle(cornerRadius: 44)
                        .stroke(Color(.label), lineWidth: 1)
                    )
                    .shadow(radius: 5)
            }
            
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
    
    private func AllChatsList() -> some View {
        ScrollView {
            ForEach(Array(chatVM.chatUserDict.sorted { $0.key.lastUpdated > $1.key.lastUpdated }), id: \.key) { (chat, user) in
                VStack {
                    NavigationLink(destination: MessageDetailView(messagesVM: MessagesViewModel(fromUser: session.userSession!, toUser: user)).onDisappear{chatVM.loadChatDataIfNeeded(forUser: session.userSession!)}) {
                        
                        HStack(spacing: 16) {
                            UrlImage(url: user.profileImageUrl ?? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                                .clipped()
                                .cornerRadius(44)
                                .overlay(RoundedRectangle(cornerRadius: 44)
                                    .stroke(Color(.label), lineWidth: 1)
                                )
                                .shadow(radius: 5)
                                        
                            VStack(alignment: .leading) {
                                Text("\(user.firstName) \(user.lastName)")
                                    .font(.system(size: 16, weight: .bold))
                                Text("\(chat.lastMessage)")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(.lightGray))
                                    .multilineTextAlignment(.leading)
                            }
                            Spacer()
                            
                            Text("\(dateFormatter.formatTimestampSince(chat.lastUpdated))")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        
                    }.foregroundColor(.black)
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
                    .simultaneousGesture(TapGesture().onEnded{
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    })
                
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
    }
}

struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()
    }
}
