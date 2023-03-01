//
//  ChatViewModel.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/28/23.
//

import Foundation
import Firebase

class ChatViewModel: ObservableObject {
    
    @Published var messages: [Message] = []
    @Published var lastMessageId: String = ""
        
    @Published var fromUser: User
    @Published var toUser: User
    
    init(fromUser: User, toUser: User) {
        self.fromUser = fromUser
        self.toUser = toUser
    }
    
    func sendMessage(message: String, toChat: String? = nil) {
        
        // If chat is specified.
        if toChat != nil {
            // TODO: add message to chat commonChats[0] and update most recently sent message.
            
            return
        }
        
        // Else if chat isn't specified.
        // First check if users have messaged eachother before to decide if we need to craete a new chat or add to an existing one.
        if fromUser.chats != nil && toUser.chats != nil {
            let commonChats = fromUser.chats!.filter { toUser.chats!.contains($0) }
            if commonChats.count == 1 {
                print("\(fromUser.firstName) and \(toUser.firstName) have previously chatted in chat: \(commonChats[0])")
                // TODO: Pull/display previous messages, then add message to chat commonChats[0] and update most recently sent message.
                
                                
            } else {
                print("sendMessage() Error: \(fromUser.firstName) and \(toUser.firstName) have \(commonChats.count) chats with eachother.")
            }
        } else {
            print("\(fromUser.firstName) and \(toUser.firstName) have never messages eachother before.")
            // Create new chat and add message
            if fromUser.chats == nil || toUser.chats == nil { // One of the users has no chat conversations
                // Create chat and add message
                self.createChat(fromUser: fromUser.userId, toUser: toUser.userId, onSuccess: {chat in // If users have never previously chatted: createChat
                    print("Successfully created chat: \(chat). Now about to addMessage()")
                    
                    self.addMessage(text: message, fromUser: self.fromUser.userId, toChat: chat.id, onSuccess: {message in
                        print("Successfully added message: \(message)")
                    }, onError: {error in
                        print("Error adding message: \(error)")
                    })
                    
                }, onError: {error in
                    print("Error creating chat: \(error)")
                })
            }
        }
        
    }
    
    private func createChat(fromUser: String, toUser: String, onSuccess: @escaping(_ chat: Chat) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        // Create Firestore Chat reference.
        let chatDocumentRef = Ref.FIRESTORE_COLLECTION_CHATS.document()
        
        // Create Chat object.
        let newChat = Chat(id: chatDocumentRef.documentID, createdAt: Date(), createdBy: fromUser, lastUpdated: Date(), members: [fromUser, toUser])
        
        // Encode Chat object to dictionary
        guard let dict = try? newChat.toDictionary() else {return}
        
        chatDocumentRef.setData(dict) {error in
            if let error = error {
                onError(error.localizedDescription)
            } else {
                print("Chat \(newChat.id) successfully created.")
                onSuccess(newChat)
            }
        }
        
        // Add chatId to fromUser's array of chats.
        Ref.FIRESTORE_COLLECTION_USERS.document(fromUser).updateData([
            "chat": FieldValue.arrayUnion([chatDocumentRef.documentID])
        ])
        
        // Add chatId to toUser's array of chats.
        Ref.FIRESTORE_COLLECTION_USERS.document(toUser).updateData([
            "chat": FieldValue.arrayUnion([chatDocumentRef.documentID])
        ])
        
        
    }
    
    private func addMessage(text: String, fromUser: String, toChat: String, onSuccess: @escaping(_ message: Message) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        let messageDocumentRef = Ref.FIRESTORE_COLLECTION_MESSAGES.document(toChat).collection("messages").document()
        
        let newMessage = Message(id: messageDocumentRef.documentID, fromUser: fromUser, text: text, received: false, timestamp: Date())
        
        guard let dict = try? newMessage.toDictionary() else {return}
        
        messageDocumentRef.setData(dict) {error in
            if let error = error {
                onError(error.localizedDescription)
            } else {
                print("Message \(newMessage.text) was added to Chat: \(toChat).")
                onSuccess(newMessage)
            }
        }
    }
    
}
