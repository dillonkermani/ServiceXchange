//
//  MessageDetailView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/26/23.
//

import SwiftUI

struct MessageDetailView: View {
    
    @ObservedObject var chatVM = ChatViewModel()
    
    
    var fromUser: User
    var toUser: User
    
    
    var body: some View {
        VStack {
            VStack {
                TitleRow()
                
                ScrollViewReader { proxy in
                    ScrollView {
                        /*
                        ForEach(messageVM.messages, id: \.id) { message in
                            MessageBubble(message: message)
                        }
                         */
                    }
                    .padding(.top, 10)
                    .background(.white)
                    /*
                    .onChange(of: messageVM.lastMessageId) { id in
                        // When the lastMessageId changes, scroll to the bottom of the conversation
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                     */
                }
                
            }
            .background(CustomColor.sxcgreen)
            
            MessageTextField(message: chatVM.message)

        }
    }
    
    private func MessageTextField(message: String) -> some View {
        HStack {
            // Custom text field created below
            CustomTextField(placeholder: Text("Enter your message here"), text: $chatVM.message)
                            .frame(height: 52)
                            .disableAutocorrection(true)
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(35)

            Button {
                chatVM.createChat(fromUser: fromUser.userId, toUser: toUser.userId, onSuccess: {chat in // If users have never previously chatted: createChat
                    print("Successfully created chat: \(chat). Now about to addMessage()")
                    
                    chatVM.addMessage(text: message, fromUser: fromUser.userId, toChat: chat.id, onSuccess: {message in
                        print("Successfully added message: \(message)")
                    }, onError: {error in
                        print("Error adding message: \(error)")
                    })
                    
                }, onError: {error in
                    print("Error creating chat: \(error)")
                })
                chatVM.message = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(CustomColor.sxcgreen)
                    .cornerRadius(50)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.gray)
        .cornerRadius(50)
        .padding()
    }
    
    private func TitleRow() -> some View {
        HStack(spacing: 20) {
            AsyncImage(url: URL(string: toUser.profileImageUrl ?? "")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                Text("\(toUser.firstName) \(toUser.lastName)")
                    .font(.title).bold()
                
                Text("Online")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "phone.fill")
                .foregroundColor(.gray)
                .padding(10)
                .background(.white)
                .cornerRadius(50)
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

struct MessageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetailView(fromUser: User(userId: "", firstName: "Sending", lastName: "User", email: "", isServiceProvider: false, listingIDs: []), toUser: User(userId: "", firstName: "Recipient", lastName: "User", email: "", isServiceProvider: false, listingIDs: []))
    }
}

struct MessageBubble: View {
    var message: Message
    @State private var showTime = false
    
    var body: some View {
        VStack(alignment: message.received ? .leading : .trailing) {
            HStack {
                Text(message.text)
                    .padding()
                    .background(message.received ? .gray : CustomColor.sxcgreen)
                    .cornerRadius(30)
            }
            .frame(maxWidth: 300, alignment: message.received ? .leading : .trailing)
            .onTapGesture {
                showTime.toggle()
            }
            
            if showTime {
                Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(message.received ? .leading : .trailing, 25)
            }
        }
        .frame(maxWidth: .infinity, alignment: message.received ? .leading : .trailing)
        .padding(message.received ? .leading : .trailing)
        .padding(.horizontal, 10)
    }
}
