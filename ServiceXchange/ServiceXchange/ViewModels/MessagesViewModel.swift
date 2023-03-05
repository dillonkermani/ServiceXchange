//
//  MessagesViewModel.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/28/23.
//

import Foundation
import Firebase

class MessagesViewModel: ObservableObject {
    
    @Published var messages: [Message] = []
    @Published var lastMessageId: String = ""
        
    @Published var fromUser: User
    @Published var toUser: User
    
    init(fromUser: User, toUser: User) {
        self.fromUser = fromUser
        self.toUser = toUser
    }
    
    func sendMessage(message: String, toChat: String? = nil) {
        print("\nsendMessage() called\n")
        
        // If toChat is specified.
        if toChat != nil {
            // TODO: add message to chat commonChats[0] and update most recently sent message.
            // (Assumes that getMessages() has already been called.)
            self.addMessage(text: message, fromUser: self.fromUser.userId, toChat: toChat!, onSuccess: {message in
                print("Successfully added message: \(message)")
                // Add chatId to fromUser's array of chats.
                Ref.FIRESTORE_COLLECTION_CHATS.document(toChat!).updateData([
                    "lastUpdated": Date().timeIntervalSince1970
                ])
            }, onError: {error in
                print("Error adding message: \(error)")
            })
            return
        }
        
        // If either user has never chatted before.
        if (fromUser.chats == nil || toUser.chats == nil) {
            self.createChat(fromUser: fromUser.userId, toUser: toUser.userId, onSuccess: {chat in // If users have never previously chatted: createChat
                print("Successfully created chat: \(chat). Now about to addMessage()")
                
                self.addMessage(text: message, fromUser: self.fromUser.userId, toChat: chat.id, onSuccess: {message in
                    print("Successfully added message: \(message)")
                    self.refreshChatParticipantData()
                    self.getMessages(fromChat: chat.id)
                    
                }, onError: {error in
                    print("Error adding message: \(error)")
                })
            }, onError: {error in
                print("Error creating chat: \(error)")
            })
            return
        }
                            
        // If users share a chat.
        let commonChats = fromUser.chats!.filter { toUser.chats!.contains($0) }
        print("Overlap between chats: \(fromUser.chats!) and \(toUser.chats!) = \(commonChats)")
        if commonChats.count == 1 {
            print("\(fromUser.firstName) and \(toUser.firstName) have previously chatted in chat: \(commonChats[0])")
            // TODO: Pull/display previous messages, then add message to chat commonChats[0] and update most recently sent message.
            getMessages(fromChat: commonChats[0])
            
            self.addMessage(text: message, fromUser: self.fromUser.userId, toChat: commonChats[0], onSuccess: {message in
                print("Successfully added message: \(message)")
            }, onError: {error in
                print("Error adding message: \(error)")
            })
            return
                            
        } else { // Else if users don't share a chat
            self.createChat(fromUser: fromUser.userId, toUser: toUser.userId, onSuccess: {chat in // If users have never previously chatted: createChat
                print("Successfully created chat: \(chat). Now about to addMessage()")
                
                self.addMessage(text: message, fromUser: self.fromUser.userId, toChat: chat.id, onSuccess: {message in
                    print("Successfully added message: \(message)")
                    self.refreshChatParticipantData()
                    self.getMessages(fromChat: chat.id)
                    
                }, onError: {error in
                    print("Error adding message: \(error)")
                })
            }, onError: {error in
                print("Error creating chat: \(error)")
            })
            return
        }
        
        
    }
    
    func getMessages(fromChat: String? = nil) {
        
        
        print("\ngetMessages() called.\n")
        
        var chatId = fromChat
        
        if fromUser.chats == nil || toUser.chats == nil {
            print("either user has no chat history")
            return
        }
        
        // If no chat is specified, check if users have a shared chat.
        if chatId == nil {
            let commonChats = fromUser.chats!.filter { toUser.chats!.contains($0) }
            if commonChats.count != 1 {
                // Users don't have a shared chat.
                print("users don't have a shared chat")
                return
            } else {
                // Else, set chatId to shared chat
                chatId = commonChats[0]
            }
        }
        
        if chatId != nil {
            Ref.FIRESTORE_COLLECTION_MESSAGES.document(chatId!).collection("messages").order(by: "timestamp", descending: false).addSnapshotListener { querySnapshot, error in
                
                // If we don't have documents, exit the function
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(String(describing: error))")
                    return
                }
                
                for doc in documents {
                    print("\n\n\(doc.data())\n\n")
                }
                
                // Mapping through the documents
                self.messages = documents.compactMap { document -> Message? in
                    do {
                        // Converting each document into the Message model
                        return try document.data(as: Message.self)
                    } catch {
                        // If we run into an error, print the error in the console
                        print("Error decoding document into Message: \(error)")
                        
                        // Return nil if we run into an error - but the compactMap will not include it in the final array
                        return nil
                    }
                }
                
                // Sorting the messages by sent date
                //self.messages.sort { $0.timestamp < $1.timestamp }
                
                print("Successfully loaded messages: \(self.messages)")
                
                // Getting the ID of the last message so we automatically scroll to it in ContentView
                if let id = self.messages.last?.id {
                    self.lastMessageId = id
                }
            }
        }
    }
    
    private func createChat(fromUser: String, toUser: String, onSuccess: @escaping(_ chat: Chat) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        print("\ncreateChat() called")
        // Create Firestore Chat reference.
        let chatDocumentRef = Ref.FIRESTORE_COLLECTION_CHATS.document()
        
        // Create Chat object.
        let newChat = Chat(id: chatDocumentRef.documentID, createdAt: Date().timeIntervalSince1970, createdBy: fromUser, lastUpdated: Date().timeIntervalSince1970, members: [fromUser, toUser])
        
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
            "chats": FieldValue.arrayUnion([chatDocumentRef.documentID])
        ])
        
        // Add chatId to toUser's array of chats.
        Ref.FIRESTORE_COLLECTION_USERS.document(toUser).updateData([
            "chats": FieldValue.arrayUnion([chatDocumentRef.documentID])
        ])
        
        
    }
    
    private func addMessage(text: String, fromUser: String, toChat: String, onSuccess: @escaping(_ message: Message) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        print("\naddMessage() called\n")
        
        let messageDocumentRef = Ref.FIRESTORE_COLLECTION_MESSAGES.document(toChat).collection("messages").document()
        
        let newMessage = Message(id: messageDocumentRef.documentID, fromUser: fromUser, text: text, received: false, timestamp: Date().timeIntervalSince1970)
        
        guard let dict = try? newMessage.toDictionary() else {return}
        
        messageDocumentRef.setData(dict) {error in
            if let error = error {
                onError(error.localizedDescription)
            } else {
                print("\"\(newMessage.text)\" was added to Chat: \(toChat).")
                self.sendPushNotification(to: self.toUser.fcmToken ?? "", title: "\(self.fromUser.firstName) \(self.fromUser.lastName)", body: newMessage.text)
                onSuccess(newMessage)
            }
        }
    }
    
    private func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(Constants.fcmServerKey)", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print("Send push notification error:", err.debugDescription)
            }
        }
        task.resume()
    }
    
    
    
    func refreshChatParticipantData() {
        
        // TODO: Refresh fromUser and toUser with fresh user data.
        
        let toUserRef = Ref.FIRESTORE_DOCUMENT_USERID(userId: toUser.userId)
        toUserRef.getDocument { (document, error) in
            if let dict = document?.data() {
                guard let decoderUser = try? User.init(fromDictionary: dict) else {return}
                self.toUser = decoderUser
            }
        }
        
        let fromUserRef = Ref.FIRESTORE_DOCUMENT_USERID(userId: fromUser.userId)
        fromUserRef.getDocument { (document, error) in
            if let dict = document?.data() {
                guard let decoderUser = try? User.init(fromDictionary: dict) else {return}
                self.fromUser = decoderUser
            }
        }
        
    }
    
}
