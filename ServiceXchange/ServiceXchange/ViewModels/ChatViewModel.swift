//
//  ChatViewModel.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/28/23.
//

import Foundation
import Firebase

class ChatViewModel: ObservableObject {
    
    
        
    @Published var chatUserDict: [Chat : User] = [:]
    @Published var mostRecentChat: Double = 0
    
    // Increases efficiency by only refreshing chat data when a newer message exists.
    func loadChatDataIfNeeded(forUser: User) {
        var chatsReloaded = false
        
        
        for chatId in forUser.chats ?? [] { // For chat user is a part of:
            Ref.FIRESTORE_COLLECTION_CHATS.document(chatId).getDocument { (document, err) in // Load Chat
                if document != nil {
                    let dict = document!.data()
                    if dict != nil {
                        guard let decodedChat = try? Chat.init(fromDictionary: dict!) else { return } // Decode Chat
                        // If there is a chat that's newer than the one represented by 'mostRecentChat'.
                        if decodedChat.lastUpdated > self.mostRecentChat {      // If there exists a chat has been updated more recently than the most recent call to this function.
                            if !chatsReloaded {
                                self.reloadAllChats(forUser: forUser)
                                chatsReloaded = true
                            }
                        }
                    }
                }
            }
        }
    }

    private func reloadAllChats(forUser: User) {
        // For chatId in user's chats, decode and associate Chat model with recieipient User model.
        print("Reloading chats")
        chatUserDict = [:]
        for chatId in forUser.chats ?? [] {
            Ref.FIRESTORE_COLLECTION_CHATS.document(chatId).getDocument { (document, err) in
                if document != nil {
                    let dict = document!.data()
                    if dict != nil {
                        guard let decodedChat = try? Chat.init(fromDictionary: dict!) else { return }
                        if decodedChat.lastUpdated > self.mostRecentChat {
                            self.mostRecentChat = decodedChat.lastUpdated
                        }
                        for userId in decodedChat.members { // This for loop only runs at most 2 times because chats currently only support 2 members.
                            if userId != forUser.userId {
                                Ref.FIRESTORE_COLLECTION_USERS.document(userId).getDocument { (document, err) in
                                    if let document = document, document.exists {
                                        let dict = document.data()
                                        guard let decodedUser = try? User.init(fromDictionary: dict!) else { return }
                                        self.chatUserDict[decodedChat] = decodedUser
                                    } else {
                                        print("Document does not exist")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
}
