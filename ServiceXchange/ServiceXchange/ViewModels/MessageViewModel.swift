//
//  MessageViewModel.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 2/26/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class MessageViewModel: ObservableObject {
    // Firebase Cloud Messaging server key
    private let serverKey = "<your_fcm_server_key_here>"

    // Firebase Cloud Messaging API endpoint
    private let fcmURL = URL(string: "https://fcm.googleapis.com/fcm/send")!
    
    @Published private(set) var messages: [Message] = [Message(id: "", text: "Mesage1", received: true, timestamp: Date()), Message(id: "", text: "Mesage2", received: false, timestamp: Date())]
    @Published private(set) var lastMessageId: String = ""
    
    // Create an instance of our Firestore database
    let db = Firestore.firestore()
    
    // On initialize of the MessagesManager class, get the messages from Firestore
    init() {
        //getMessages()
    }
    
    // Add a message in Firestore
    func sendMessage(text: String, onSuccess: @escaping(_ message: Message) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        do {
            // Create a new Message instance, with a unique ID, the text we passed, a received value set to false (since the user will always be the sender), and a timestamp
            let message = Message(id: "\(UUID())", text: text, received: false, timestamp: Date())
            
            
            guard let dict = try? message.toDictionary() else { return }
            
            //adding listing without the image to the firebase
            let message_ref = Ref.FIRESTORE_COLLECTION_MESSAGES.addDocument(data: dict){ error in
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
            }
            onSuccess(message)
            
        }
    }

    // Send a message to the specified FCM token
    func sendFCMMessage(to token: String, with message: String) {
        // Construct the FCM message
        let fcmMessage: [String: Any] = [
            "to": token,
            "notification": [
                "body": message
            ]
        ]

        // Convert the FCM message to JSON data
        let jsonData = try! JSONSerialization.data(withJSONObject: fcmMessage, options: [])

        // Create an HTTP POST request to the FCM API endpoint
        var request = URLRequest(url: fcmURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData

        // Send the request asynchronously using URLSession
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle any errors that occurred during the request
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
                return
            }

            // Check the HTTP status code of the response
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                print("Invalid HTTP response")
                return
            }

            // Message sent successfully
            print("Message sent to \(token)")
        }

        task.resume()
    }
    
    

    // Read message from Firestore in real-time with the addSnapShotListener
    func getMessages() {
        db.collection("messages").addSnapshotListener { querySnapshot, error in
            
            // If we don't have documents, exit the function
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            // Mapping through the documents
            self.messages = documents.compactMap { document -> Message? in
                do {
                    // Converting each document into the Message model
                    // Note that data(as:) is a function available only in FirebaseFirestoreSwift package - remember to import it at the top
                    return try document.data(as: Message.self)
                } catch {
                    // If we run into an error, print the error in the console
                    print("Error decoding document into Message: \(error)")

                    // Return nil if we run into an error - but the compactMap will not include it in the final array
                    return nil
                }
            }
            
            // Sorting the messages by sent date
            self.messages.sort { $0.timestamp < $1.timestamp }
            
            // Getting the ID of the last message so we automatically scroll to it in ContentView
            if let id = self.messages.last?.id {
                self.lastMessageId = id
            }
        }
    }
    
    
}

