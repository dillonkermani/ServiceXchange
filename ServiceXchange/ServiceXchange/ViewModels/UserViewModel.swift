//
//  UserViewModel.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 2/8/23.
//

import Foundation
import SwiftUI
//import Firebase
import FirebaseCore
import FirebaseAuth



let mySkeletonUser = User(
    userId: "",
    firstName: "",
    lastName: "",
    email: "",
    isServiceProvider: false,
    listingIDs: [],
    
    profileImageUrl: "",
    descriptiveImageStr: "",
    companyName: "",
    bio: "",
    primaryLocationServed: ""
)


class UserViewModel: ObservableObject{
    
    @EnvironmentObject var session: SessionStore
    
    //local storage of variables here are updated live
    
    @Published var localUserId: String = "" //maybe we want this so that we dont have to use
                                            //   session store exect for at sign in
    
    @Published var skUser : User = mySkeletonUser
    
    @Published var initialized: Bool = false
    @Published var localProfileImageUrl: String = ""
    @Published var localCompanyName: String = ""
    @Published var localBio: String = ""
    @Published var localPrimaryLocationServed: String = ""
    @Published var localDescriptiveImageStr: String = ""
    
    @Published var imageName: String = "start"
    
    @Published var loadingData: Bool = false
    
    
    
    func updateLocalUserVariables(user : User) {
        
        self.initialized = true
        
        self.localUserId = user.userId
        self.localBio = user.bio ?? "none"
        self.localCompanyName = user.companyName ?? "none"
        self.localPrimaryLocationServed = user.primaryLocationServed ?? "none"
        self.localProfileImageUrl = user.profileImageUrl ?? ""
        self.localDescriptiveImageStr = user.descriptiveImageStr ?? ""
        
        
        //updateing the skeleton user
        skUser.bio = user.bio ?? "none"
        skUser.companyName = user.companyName ?? "none"
        skUser.primaryLocationServed = user.primaryLocationServed ?? "none"
        skUser.profileImageUrl = user.profileImageUrl ?? "none"
        skUser.descriptiveImageStr = user.descriptiveImageStr ?? "none"
        
    }//update local user variables fucntion
    
    //clear the local variables --> used for logout functionality
    func clearLocalUserVariables() {
        
        self.initialized = false
        
        self.localUserId = ""
        self.localBio = ""
        self.localCompanyName = ""
        self.localPrimaryLocationServed = ""
        self.localProfileImageUrl = ""
    }
    
    
    //store user data into
    func update_user_info(userId : String, company_name: String, location_served: String, bio: String, profileImageData: Data, backgroundImageData: Data, onError: @escaping(_ errorMessage: String) -> Void){
        
        self.loadingData = true
        
        print("in updating function")
        
        //this is a reference to soemthing that has user stuff in it
        let user_ref = Ref.FIRESTORE_DOCUMENT_USERID(userId: userId)
        
        //update the local variables as long as they are not an empty string
        
        if bio != "" { self.localBio  = bio }
        if location_served != "" { self.localPrimaryLocationServed = location_served }
        if company_name != "" { self.localCompanyName = company_name }
        
        
        //for skUser structure
        if bio != "" { self.skUser.bio  = bio }
        if location_served != "" { self.skUser.primaryLocationServed = location_served }
        if company_name != "" { self.skUser.companyName = company_name }
        
        
        
        //updates all textual data to firebase
        user_ref.updateData( [
            "companyName": localCompanyName,
            "primaryLocationServed": localPrimaryLocationServed,
            "bio": localBio,
        ] )
        
        //now lets work on the image
        
        updateImages2(imageData: profileImageData,isProfile: true, userId: userId)
        
        updateImages2(imageData: backgroundImageData, isProfile: false, userId: userId)
        
        self.loadingData = false
       
        }//update variables function
        
   
    
    //going forwords change all to user and try to make only one call 
    //maybe in here check if both values are optional and only do a db call once
    private func updateImages2(imageData: Data, isProfile: Bool, userId : String){
        
        let user_ref = Ref.FIRESTORE_DOCUMENT_USERID(userId: userId)
        
        //check if there is an image to add, if not then just return
        if imageData.isEmpty {
            print("imageData is empty")
            return
        }
        
        if isProfile{
            self.imageName = "\(userId)-profilepic.jpg"
        }
        else {
            self.imageName = "\(userId)-backgroundpic.jpg"
        }
        
        print("image name is ", imageName)
        

        //this a thing that you put image into and it updates image to firebase
        let img_ref = Ref.FIREBASE_STORAGE.reference().child(imageName)
        
        //give error if there is no image data
        img_ref.putData(imageData) {(metadata, error) in
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
                
                if isProfile {
                    
                    //now comvert downloadURL back to string and store into the local variable
                    self.localProfileImageUrl = downloadURL.absoluteString
                    self.skUser.profileImageUrl = downloadURL.absoluteString
                  //store the url of the image to firebase
                  user_ref.updateData( [
                      "profileImageUrl": downloadURL.absoluteString,
                  ] )
                
                 
                    
                }
                else {
                    self.localDescriptiveImageStr = downloadURL.absoluteString
                    self.skUser.descriptiveImageStr = downloadURL.absoluteString
                    user_ref.updateData(["descriptiveImageStr": downloadURL.absoluteString])
                   
                }
                
            }
             return
        }
    }//updateImages2
    
    
    
    
//    func editTest( onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) async {
//
//        let _ = "bouta sleep"
//        sleep(3)
//        let _ = "yo good nap"
//        onSuccess()
//    }
//
    
    //delete a user account from the authentification storage
    func deleteUserAccount () {
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
              print("unable to delete account")
            // An error happened.
          } else {
              print("user account deleted")
            // Account deleted.
          }
        }
        
    }
    

    
    
    //need to reauth before we can delete a user before you delete their account
    func reAuthUser(userProvidedPassword: String){
       
        let user = Auth.auth().currentUser

        let credential = EmailAuthProvider.credential(withEmail: (user?.email!)!, password: userProvidedPassword)
        user!.reauthenticate(with: credential) {  result, error in
                     if let error = error {
                         print("error re-auth user - \(error)")
                     } else {
                         print("success reauth-user")
                         
                         //delete the firebase information
                         Ref.FIRESTORE_COLLECTION_USERS.document(self.localUserId).delete() { err in
                             if let err = err {
                                 print("Error removing document: \(err)")
                             } else {
                                 print("Document successfully removed!")
                             }
                         }
                         self.deleteUserAccount()
                         
                         
                     }
                 }
    }//reAuth
    
    
}//userViewModel













//    func addListing(posterId: String, onSuccess: @escaping(_ listing: Listing) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
//
//
//
//        let listing = Listing(posterId: posterId, title: self.title, description: self.description, datePosted: Date().timeIntervalSince1970)
//
//        guard let dict = try? listing.toDictionary() else { return }
//
//        let listing_ref = Ref.FIRESTORE_COLLECTION_LISTINGS.addDocument(data: dict){ error in
//            if let error = error {
//                onError(error.localizedDescription)
//                return
//            }
//        }
//    }

