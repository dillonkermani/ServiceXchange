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
    
    @EnvironmentObject var session: SessionStore
    
    //local storage of variables here are updated live
    
    @Published var localUserId: String = "" //maybe we want this so that we dont have to use
                                            //   session store exect for at sign in
    
    
    @Published var initialized: Bool = false
    @Published var localProfileImageUrl: String = ""
    @Published var localCompanyName: String = ""
    @Published var localBio: String = ""
    @Published var localPrimaryLocationServed: String = ""
    
    
    
    
    func updateLocalUserVariables(user : User) {
        
        self.initialized = true
        
        self.localUserId = user.userId
        self.localBio = user.bio ?? "none"
        self.localCompanyName = user.companyName ?? "none"
        self.localPrimaryLocationServed = user.primaryLocationServed ?? "none"
        self.localProfileImageUrl = user.profileImageUrl ?? "none"
        
    }//update local user variables fucntion
    
    
    //pull the values of user data and store in local variables
    //this shit is actually mega unessissary
    func loadLocalUserVariables(userId : String){
        
        //create reference to firebase user -> userid document
        let userDocRef = Ref.FIRESTORE_DOCUMENT_USERID(userId: userId)
        
        
        //get the user document data and store it as a map in dataDescription variable
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()
                self.localUserId = dataDescription?["userId"]! as? String ?? "unknown"
                self.localProfileImageUrl = dataDescription?["profileImageUrl"]! as? String ?? "unknown"
                self.localCompanyName = dataDescription?["companyName"]! as? String ?? "unknown"
                self.localBio = dataDescription?["bio"]! as? String ?? "unknown"
                self.localPrimaryLocationServed = dataDescription?["primaryLocationServed"]! as? String ?? "unknown"
//                print("should be compName: ", self.localCompanyName)
//                print("localBio should be: ", self.localBio)
//                print("localPrimaryLocationServed: ", self.localPrimaryLocationServed)
//                print("localProfileImageUrl: ", self.localProfileImageUrl)
                
            } else {
                print("Document does not exist")
            }
        }
    }//load local variables function
    
    
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
        
        //update the local variables --> everytime you declair a new viewmodel are they not the same?
        self.localBio  = bio
        self.localPrimaryLocationServed = location_served
        self.localCompanyName = company_name
        
        
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
                
                //now comvert downloadURL back to string and store into the local variable
                //or maybe in future we can make local var of typ url?
                //self.localProfileImageUrl = downloadURL as? String ?? "unknown"
                //why does this go back to orignal empty string state?
                self.localProfileImageUrl = downloadURL.absoluteString
                
                // self.session.localProfileImageUrl = downloadURL.absoluteString
                
                //print("localProfileImageUrl in try to update: \(self.localProfileImageUrl)")

                
            }
             return
        }
        
        
        
 
    }//update function
    
    

    
}



