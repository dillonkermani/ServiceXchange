//
//  UserViewModel.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 2/8/23.
//

import Foundation
import SwiftUI
import FirebaseCore


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
    
    func updateLocalUserVariables(user : User) {
        
        self.initialized = true
        
        self.localUserId = user.userId
        self.localBio = user.bio ?? "none"
        self.localCompanyName = user.companyName ?? "none"
        self.localPrimaryLocationServed = user.primaryLocationServed ?? "none"
        self.localProfileImageUrl = user.profileImageUrl ?? "none"
        self.localDescriptiveImageStr = user.descriptiveImageStr ?? "none"
        
        
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
        
        
        print("in updating function")
        
        //this is a reference to soemthing that has user stuff in it
        let user_ref = Ref.FIRESTORE_DOCUMENT_USERID(userId: userId)
        
        //update the local variables as long as they are not an empty string
        
        if bio != "" { self.localBio  = bio }
        if location_served != "" { self.localPrimaryLocationServed = location_served }
        if company_name != "" { self.localCompanyName = company_name }
        
        
        
        
        //updates all textual data to firebase
        user_ref.updateData( [
            "companyName": localCompanyName,
            "primaryLocationServed": localPrimaryLocationServed,
            "bio": localBio,
        ] )
        

        
        
        //now lets work on the image
        
        //updateUserImages(imageToUpload: backgroundImageData, isProfile: false)
        
        //updateUserImages(imageToUpload: profileImageData, isProfile: true)
        
        updateImages2(imageData: profileImageData,isProfile: true, userId: userId)
        
        updateImages2(imageData: backgroundImageData, isProfile: false, userId: userId)
        
        /*
        //check if there is an image to add, if not then just return
        if profileImageData.isEmpty {
            print("imageData is empty")
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
                self.localProfileImageUrl = downloadURL.absoluteString
            }
             return
        }
        */
    }//update function
    
    
    
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
        
        //create semi unique to be changed later image name
        //let image_name = "\(userId)-profilepic.jpg"
        
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
                  //store the url of the image to firebase
                  user_ref.updateData( [
                      "profileImageUrl": downloadURL.absoluteString,
                  ] )
                
                  //now comvert downloadURL back to string and store into the local variable
                  self.localProfileImageUrl = downloadURL.absoluteString
                
                }
                else {
                    user_ref.updateData(["descriptiveImageStr": downloadURL.absoluteString])
                    self.localDescriptiveImageStr = downloadURL.absoluteString
                }
                
            }
             return
        }
    }
    
    
    private func updateUserImages(imageToUpload: Data, isProfile: Bool){
        
        //this is a reference to soemthing that has user stuff in it
        let userRef = Ref.FIRESTORE_DOCUMENT_USERID(userId: self.localUserId)
        
        if isProfile {
            imageName = "\(self.localUserId)-profileimage.jpg"
        }
        else {
            imageName = "\(self.localUserId)-backgroundimage.jpg"
        }
        
        //make a reference for the storage of the image
        let imageRef = Ref.FIREBASE_STORAGE.reference().child(imageName)
        
        imageRef.putData(imageToUpload) {(metadata, error) in
            guard let _ = metadata else {
                print("no image metadata...")
                return
            } //if no image data return
            
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("image upload failed: no download url")
                    return
                }
                
                if isProfile {
                    //store the url of the image to firebase
                    userRef.updateData( [
                        "profileImageUrl": downloadURL.absoluteString,
                    ] )
                    //now comvert downloadURL back to string and store into the local variable
                    self.localProfileImageUrl = downloadURL.absoluteString
                }
                else {
                    userRef.updateData(["descriptiveImageStr": downloadURL.absoluteString])
                    self.localDescriptiveImageStr = downloadURL.absoluteString
                }
                
            }//downloadURL
            
        }//putData
        
    }//update user image function
 
    
}


