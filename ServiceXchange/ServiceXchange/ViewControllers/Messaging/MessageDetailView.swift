//
//  MessageDetailView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/26/23.
//

import SwiftUI

struct MessageDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var session: SessionStore

    @StateObject var messagesVM: MessagesViewModel
    
    @State var message = ""
    
    var body: some View {
        VStack {
            
            TitleRow()
                .background(CustomColor.sxcgreen)
            
            VStack {
                if !messagesVM.messages.isEmpty {
                    ScrollViewReader { proxy in
                        VStack {
                            ScrollView {
                                ForEach(messagesVM.messages, id: \.id) { message in
                                    MessageBubble(message: message)
                                }
                            }
                        }.padding(10)
                        .background(.white)
                        .cornerRadius(30, corners: [.topLeft, .topRight]) // Custom cornerRadius modifier added in Extensions file
                        .onChange(of: messagesVM.lastMessageId) { id in
                            // When the lastMessageId changes, scroll to the bottom of the conversation
                            withAnimation {
                                proxy.scrollTo(id, anchor: .bottom)
                            }
                        }
                    }
                } else {
                        Spacer()
                        Text("No message history")
                        Spacer()
                }
            }.background(messagesVM.messages.isEmpty ? .white : CustomColor.sxcgreen)
                .offset(y: messagesVM.messages.isEmpty ? 0 : -10)

            MessageTextField()

        }
        .onAppear {
            messagesVM.getMessages()
        }
        .onDisappear {
            session.refreshUserSession()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 17)).bold()
                        }.foregroundColor(.black)
                    }
                    
                }
            }
        }
        .gesture(DragGesture()
            .onEnded { value in
                let direction = detectDirection(value: value)
                if direction == .left {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        )
    }
    
    func MessageTextField() -> some View {
        HStack {
            // Custom text field created below
            CustomTextField(placeholder: Text("Enter your message here"), text: $message)
                

            Button {
                messagesVM.sendMessage(message: message)
                message = ""
                messagesVM.refreshChatParticipantData()
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(CustomColor.sxcgreen)
                    .cornerRadius(30)
                    .padding(.trailing, 15)
                    
            }
        }
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(message.isEmpty ? .black : CustomColor.sxcgreen, lineWidth: 2)
        )
        .padding(15)
    }
    
    private func TitleRow() -> some View {
        HStack(spacing: 20) {
            UrlImage(url: messagesVM.toUser.profileImageUrl ?? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png")
                .scaledToFill()
                .frame(width: 44, height: 44)
                .clipped()
                .cornerRadius(44)
                .overlay(RoundedRectangle(cornerRadius: 44)
                    .stroke(Color(.label), lineWidth: 1)
                )
                .shadow(radius: 5)
            
            VStack(alignment: .leading) {
                Text("\(messagesVM.toUser.firstName) \(messagesVM.toUser.lastName)")
                    .font(.title).bold()
                
                Text("Online")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
        .padding()
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }

    var body: some View {
        ZStack(alignment: .leading) {
            // If text is empty, show the placeholder on top of the TextField
            if text.isEmpty {
                placeholder
                .opacity(0.5)
            }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
            
        }.padding()
    }
}

struct MessageBubble: View {
    @EnvironmentObject var session: SessionStore

    var message: Message
    @State private var showTime = false
    
    var body: some View {
        VStack(alignment: message.fromUser != session.userSession?.userId ? .leading : .trailing) {
            HStack {
                Text(message.text)
                    .padding()
                    .background(message.fromUser != session.userSession?.userId ? .gray.opacity(0.3) : CustomColor.sxcgreen)
                    .cornerRadius(25)
            }
            .frame(maxWidth: 300, alignment: message.fromUser != session.userSession?.userId ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            
            if showTime {
                Text("\(message.timestamp)")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.fromUser != session.userSession?.userId ? .leading : .trailing, 10)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.fromUser != session.userSession?.userId ? .leading : .trailing)
        .padding(message.fromUser != session.userSession?.userId ? .leading : .trailing)
    }
}

struct MessageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetailView(messagesVM: MessagesViewModel(fromUser: User(userId: "", firstName: "Sending", lastName: "User", email: "", isServiceProvider: false, listingIDs: []), toUser: User(userId: "", firstName: "Recipient", lastName: "User", email: "", isServiceProvider: false, listingIDs: [])))
    }
}
