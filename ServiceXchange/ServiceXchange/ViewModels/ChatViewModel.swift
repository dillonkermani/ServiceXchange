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

    func loadChatData(forUser: User) {
        // For chatId in user's chats, decode and associate Chat model with recieipient User model.
        for chatId in forUser.chats ?? [] {
            Ref.FIRESTORE_COLLECTION_CHATS.document(chatId).getDocument { (document, err) in
                if document != nil {
                    let dict = document!.data()
                    if dict != nil {
                        guard let decodedChat = try? Chat.init(fromDictionary: dict!) else { return }
                        let recipientId = decodedChat.members.filter{ $0 == forUser.userId }
                        for userId in decodedChat.members {
                            if userId != forUser.userId {
                                Ref.FIRESTORE_COLLECTION_USERS.document(userId).getDocument { (document, err) in
                                    if document != nil {
                                        let dict = document!.data()
                                        guard let decodedUser = try? User.init(fromDictionary: dict!) else { return }
                                        self.chatUserDict[decodedChat] = decodedUser
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
