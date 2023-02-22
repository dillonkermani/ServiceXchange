//
//  EditProfileView.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 2/15/23.
//

import SwiftUI
import Kingfisher

struct CreateProfileControls {
    var pickedImageType = ""
    var showImagePicker = false
    var pickedImage = Image("user-placeholder")
    var width = (UIScreen.main.bounds.width * 0.43)
    var height = (UIScreen.main.bounds.width * 0.43)
    var showAlert = false
    var alertMessage = ""
}


struct EditProfileView: View {
    
    @EnvironmentObject var session: SessionStore
    //@ObservedObject var userVM : UserViewModel
    
    @EnvironmentObject var userVM: UserViewModel
    
    @State var controls = CreateProfileControls()
    
    //state varibles
    @State private var username: String = ""
    @State private var locationServe: String = ""
    @State private var shortBio: String = ""
    @State private var service: String = ""
    @State var ProfImageData = Data()
    
    //varibles that autofill the edit prompts if you already have somthing in that variable
    @State var companyNameTitle: String = "company name"
    @State var shortBioTitle: String = "short bio"
    @State var locationServeTitle: String = "location served"
    
    var body: some View {
        ZStack {

            VStack {

                
                //add the profile image button thing
                addProfilePhoto()

                
                
                underlinedTextField(title: companyNameTitle, text: $username, width: 310, height: 20, color: CustomColor.sxcgreen)
                underlinedTextField(title: locationServeTitle, text: $locationServe, width: 310, height: 40, color: CustomColor.sxcgreen)
                underlinedTextField(title: shortBioTitle, text: $shortBio, width: 310, height: 40, color: CustomColor.sxcgreen)
                
                //this button sends user info to databse
                //To Do -- make this button a navigation link that sends user back to the main profile
                Button(action: {
                    
                    //get the users information in the form of a unique stucture
                    //let userId = session.userSession!.userId
                    
                    let userId = userVM.localUserId
                    
                    //update values of my_user
                    userVM.update_user_info(userId: userId, company_name: username, location_served: locationServe, bio: shortBio, profileImageData: ProfImageData, onError: { errorMessage in
                        print("Update user error: \(errorMessage)")
                    })
                    

                    
                }){
                    Text("Send a user to our database")
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(20)
                
            }
        }.onAppear{
            
            if userVM.localCompanyName != "none" {
                companyNameTitle = userVM.localCompanyName
            }
            if userVM.localBio != "none"{
                shortBioTitle = userVM.localBio
            }
            if userVM.localPrimaryLocationServed != "none" {
                locationServeTitle = userVM.localPrimaryLocationServed
            }
            
            
        }
    }
    
    //create circular button that once tapped on prompts you to change user proflile image
    private func addProfilePhoto() -> some View {
       return ZStack {
         
                VStack {
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            controls.pickedImageType = "card"
                            controls.showImagePicker = true
                        }) {
                            if controls.pickedImage == Image("user-placeholder") {
                                
                                //if user does not have a profile picture yet
                                if userVM.localProfileImageUrl == "none" {
                                    ZStack {
                                        Image("blankprofile")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100.0, height: 100.0, alignment: .center)
                                            .clipShape(Circle())
                                    }
                                    
                                }
                                
                                else { //they do have a profile image -> display it
                                    ZStack {
                                        KFImage(URL(string: userVM.localProfileImageUrl))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100.0, height: 100.0, alignment: .center)
                                            .clipShape(Circle())
                                    }//ZStack
                                }
                                

                            } //if the user has not picked image
                            
                            else { //user has picked a new image
                               
                                
                                controls.pickedImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(100)
                                
                            }
                        }
        
                    

                    
                    
                }
      
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $controls.showImagePicker, content: {
                ImagePicker(showImagePicker: $controls.showImagePicker, pickedImage: $controls.pickedImage, imageData: $ProfImageData, sourceType: .photoLibrary)
                    
            })
        
    }
    
}

//struct EditProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditProfileView()
//    }
//}
