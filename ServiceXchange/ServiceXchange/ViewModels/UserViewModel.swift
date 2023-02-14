//
//  UserViewModel.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 2/8/23.
//

import Foundation
import SwiftUI
import FirebaseCore

class UserViewModel: ObservableObject{
    
    
    //local storage of variables here are updated live
    @Published var localProfileImageUrl: String = ""
    @Published var localCompanyName: String = ""
    @Published var localBio: String = ""
    @Published var localPrimaryLocationServed: String = ""
    
    
    //populate the user vm variables at the begining of a run
    
    //ask dillon how to pull the user structure in the Profile edit view
    //pass the user structure into the function and
    //what is user data type? to pass it in?
    
    
    //pull the values of user data and store in local variables
    func loadLocalUserVariables(userId : String){
        
        let userDocRef = Ref.FIRESTORE_DOCUMENT_USERID(userId: userId)
        
        //self.localCompanyName = user_ref.companyName
        
        
        //lit this updates fill out rest of the vars later and find the right place for it
        //also maybe definitly make a userId local variable so that we can only have to use sesesion once
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                //self.localProfileImageUrl = dataDescription["profileImageUrl"] ?? "unknowm"
                self.localCompanyName = dataDescription?["companyName"]! as? String ?? "unknowm"
                print(dataDescription?["companyName"]! as? String ?? "unknowm" )
                print("should be compName: ", self.localCompanyName)
                //print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
        
        
        
        /*
        user_ref.child("users/\(userId)/companyName").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.localCompanyName = snapshot.value as? String ?? "Unknown";
        });
        
        user_ref.child("users/\(userId)/profileImageUrl").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.localProfileImageUrl = snapshot.value as? String ?? "Unknown";
        });
        
        user_ref.child("users/\(userId)/bio").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.localBio = snapshot.value as? String ?? "Unknown";
        });
        
        user_ref.child("users/\(userId)/primaryLocationServed").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.localProfileImageUrl = snapshot.value as? String ?? "Unknown";
        });
        */
    }
    
    
    //store user data into
    func update_user_info(userId : String, company_name: String, location_served: String, bio: String, profileImageData: Data, onError: @escaping(_ errorMessage: String) -> Void){
        
        
        //this is a reference to soemthing that has user stuff in it
        let user_ref = Ref.FIRESTORE_DOCUMENT_USERID(userId: userId)
        
        //updates all textual data to firebase
        user_ref.updateData( [
            "companyName": company_name,
            "primaryLocationServed": location_served,
            "bio": bio,
        ] )
        
        //now lets work on the image
        
        
        //check if there is an image to add, if not then just return
        if profileImageData.isEmpty {
            return
        }
        
        //create semi unique to be changed later image name
        let image_name = "\(userId)-profilepic.jpg"
        
        //this a thing that you put image into and it updates image to firebase
        let img_ref = Ref.FIREBASE_STORAGE.reference().child(image_name)
        
        //give error if there is no image data
        img_ref.putData(profileImageData) {(metadata, error) in
            guard let _ = metadata else {
                print("no image metadata...")
                return
            }
            
            //gives us image url on success
            img_ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("image upload failed: no download url")
                    return
                }
                
                //store the url of the image to firebase
                user_ref.updateData( [
                    "profileImageUrl": downloadURL.absoluteString,
                ] )
            }
             return
        }//update function
        
        
        
 
    }
    
    
    /*
    func addListing(posterId: String, onSuccess: @escaping(_ listing: Listing) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        
        
        let listing = Listing(posterId: posterId, title: self.title, description: self.description, datePosted: Date().timeIntervalSince1970)
        
        guard let dict = try? listing.toDictionary() else { return }
        
        let listing_ref = Ref.FIRESTORE_COLLECTION_LISTINGS.addDocument(data: dict){ error in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
        }
        if self.cardImageData.isEmpty {
            onSuccess(listing)
            return
        }
        let image_name = "\(listing_ref.documentID).jpg"
        let img_ref = Ref.FIREBASE_STORAGE.reference().child(image_name)
        img_ref.putData(self.cardImageData) {(metadata, error) in
            guard let _ = metadata else {
                print("no image metadata...")
                return
            }
            img_ref.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("image upload failed: no download url")
                    return
                }
                listing_ref.updateData( [
                    "cardImageUrl": downloadURL.absoluteString,
                    "listingId": listing_ref.documentID,
                ] )
            }
                
        }
        onSuccess(listing)
    }
    */
    
    
}



