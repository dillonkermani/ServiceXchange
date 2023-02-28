//
//  ChatViewModel.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/28/23.
//

import Foundation

class ChatViewModel: ObservableObject {
    
    @Published var message = ""
    
    
    func createChat(fromUser: String, toUser: String, onSuccess: @escaping(_ chat: Chat) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        let chatDocumentRef = Ref.FIRESTORE_COLLECTION_CHATS.document()
        
        let newChat = Chat(id: chatDocumentRef.documentID, createdAt: Date(), createdBy: fromUser, lastUpdated: Date(), members: [fromUser, toUser])
        
        guard let dict = try? newChat.toDictionary() else {return}
        
        chatDocumentRef.setData(dict) {error in
            if let error = error {
                onError(error.localizedDescription)
            } else {
                print("Chat \(newChat.id) successfully created.")
                onSuccess(newChat)
            }
        }
        
    }
    
    func addMessage(text: String, fromUser: String, toChat: String, onSuccess: @escaping(_ message: Message) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
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
