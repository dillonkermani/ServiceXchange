//
//  MessageDetailView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/26/23.
//

import SwiftUI

struct MessageDetailView: View {
    
    @StateObject var chatVM: ChatViewModel
    
    @State var message = ""
    
    var body: some View {
        VStack {
            VStack {
                TitleRow()
                
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(chatVM.messages, id: \.id) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.top, 10)
                    .background(.white)
                    .onChange(of: chatVM.lastMessageId) { id in
                        // When the lastMessageId changes, scroll to the bottom of the conversation
                        withAnimation {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
                
                 
                
            }
            .background(CustomColor.sxcgreen)
            
            MessageTextField()

        }
        .onAppear {
            chatVM.getMessages()
        }
    }
    
    func MessageTextField() -> some View {
        HStack {
            // Custom text field created below
            CustomTextField(placeholder: Text("Enter your message here"), text: $message)
                            .frame(height: 52)
                            .disableAutocorrection(true)
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(35)

            Button {
                chatVM.sendMessage(message: message)
                message = ""
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
            AsyncImage(url: URL(string: chatVM.toUser.profileImageUrl ?? "")) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                Text("\(chatVM.toUser.firstName) \(chatVM.toUser.lastName)")
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
                Text("\(message.timestamp)")
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

struct MessageDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MessageDetailView(chatVM: ChatViewModel(fromUser: User(userId: "", firstName: "Sending", lastName: "User", email: "", isServiceProvider: false, listingIDs: []), toUser: User(userId: "", firstName: "Recipient", lastName: "User", email: "", isServiceProvider: false, listingIDs: [])))
    }
}
