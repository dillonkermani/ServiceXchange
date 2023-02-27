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

struct CreateDescriptiveControls {
    var pickedImageType = ""
    var showImagePicker = false
    var pickedImage = Image("user-placeholder")
    var width = (UIScreen.main.bounds.width * 0.43)
    var height = (UIScreen.main.bounds.width * 0.43)
    var showAlert = false
    var alertMessage = ""
}

//TODO have editing view look like the what the profile view will look like --doing
//TODO make imagepicker for the descriptive image
//TODO alter the userVM load data so that it includes the descriptive image


struct EditProfileView: View {
    
    @EnvironmentObject var session: SessionStore
    //@ObservedObject var userVM : UserViewModel
    
    @EnvironmentObject var userVM: UserViewModel
    
    @State var controls = CreateProfileControls()
    @State var controlsDesc = CreateDescriptiveControls()
    
    //state varibles
    @State private var username: String = ""
    @State private var locationServe: String = ""
    @State private var shortBio: String = ""
    @State private var service: String = ""
    @State var ProfImageData = Data()
    @State var backgroundImageData = Data()
    
    //varibles that autofill the edit prompts if you already have somthing in that variable
    @State var companyNameTitle: String = "company name"
    @State var shortBioTitle: String = "short bio"
    @State var locationServeTitle: String = "location served"
    
    
    @State private var userToPass : User = User(
        userId: "",
        firstName: "",
        lastName: "",
        email: "",
        isServiceProvider: false,
        listingIDs: []
    )
    @State private var thisUser : Bool = true
    
    
    var body: some View {
        ZStack {
            
            VStack {
                
                ZStack{
                    
                    addDescriptiveImage()
                        .padding(.top, -430)
                    
                    //add the profile image button thing
                    addProfilePhoto()
                        .padding(.top, -200)
                }
                
                
                underlinedTextField(title: "company name: " + companyNameTitle, text: $username, width: 310, height: 20, color: .black)
                    .padding(.top, -200)
                underlinedTextField(title: "location Served: " + locationServeTitle, text: $locationServe, width: 310, height: 40, color: .black)
                    .padding(.top, -140)
                underlinedTextField(title: "short bio: " + shortBioTitle, text: $shortBio, width: 310, height: 40, color: .black)
                    .padding(.top, -70)
                
                
                NavigationLink(destination: ProfileViewMultiTest(user: $userToPass, thisUser: $thisUser), label: {
                    Text("Save Changes")
                        .fontWeight(.semibold)
                        .font(.title)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(40)
                        .foregroundColor(.black)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color.black, lineWidth: 3)
                                .frame(width: 250, height: 50)
                        )
                }).simultaneousGesture(TapGesture().onEnded{
                    let userId = userVM.localUserId
                    userVM.update_user_info(userId: userId, company_name: username, location_served: locationServe, bio: shortBio, profileImageData: ProfImageData, backgroundImageData: backgroundImageData, onError: { errorMessage in
                        print("Update user error: \(errorMessage)")
                        sleep(1)
                    })
                    //print("hello")
                })
                
                

                
            }//VStack
                
                
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
                
                
            }.toolbar(.hidden)
        }
    
    
    

    
    //either make button able to be pressed or make a different button that pulls up the image picker
    func addDescriptiveImage() -> some View {
        
          
              return VStack {
                         Button(action: {
                             print("button pressed")
                             UIImpactFeedbackGenerator(style: .light).impactOccurred()
                             controlsDesc.pickedImageType = "card"
                             controlsDesc.showImagePicker = true
                         }) {
                             if controlsDesc.pickedImage == Image("user-placeholder") {
                                 let _ = print("this should print")
                                 
                                 //if user does not have a profile picture yet
                                 if userVM.localDescriptiveImageStr == "none" {
                                     ZStack {
                                         Image("sunsetTest")
                                               .resizable()
                                                   .aspectRatio(contentMode: .fill)
                                                   .frame(width: 400.0, height: 250.0, alignment: .top)
                                                   .clipShape(Rectangle())
                                     }
                                     
                                 }
                                 
                                 else { //they do have a profile image -> display it
                                     ZStack {
                                         KFImage(URL(string: userVM.localDescriptiveImageStr))
                                             .resizable()
                                                 .aspectRatio(contentMode: .fill)
                                                 .frame(width: 400.0, height: 250.0, alignment: .top)
                                                 .clipShape(Rectangle())
                                     }//ZStack
                                 }
                                 

                             } //if the user has not picked image
                             
                             else { //user has picked a new image
                                
                                 
                                 controlsDesc.pickedImage
                                     .resizable()
                                         .aspectRatio(contentMode: .fill)
                                         .frame(width: 400.0, height: 250.0, alignment: .top)
                                         .clipShape(Rectangle())
                                 
                             }
                         }
                     
               
       
         }.frame(maxWidth: .infinity, maxHeight: .infinity)
             .sheet(isPresented: $controlsDesc.showImagePicker, content: {
                 ImagePicker(showImagePicker: $controlsDesc.showImagePicker, pickedImage: $controlsDesc.pickedImage, imageData: $backgroundImageData, sourceType: .photoLibrary)
                     
             })
        
    }
    

    func showDetailImage() -> some View {
        return VStack {
          Image("sunsetTest")
                .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400.0, height: 250.0, alignment: .top)
                    .clipShape(Rectangle())
        }
    }
    
  //private func SaveDataButton
    
                               
    private func CustomProfileButtonView(title: String, foregroundColor: Color, backgroundColor: Color) -> some View {
        return ZStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width / 1.3, height: 50)
                .shadow(radius: 5)
                .foregroundColor(backgroundColor)
                .border(Color.black, width: 5)
            Text(title)
                .font(.system(size: 17)).bold()
                .foregroundColor(foregroundColor)
        }.cornerRadius(30)
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
                                            .frame(width: 125.0, height: 125.0, alignment: .center)
                                            .clipShape(Circle())
                                    }
                                    
                                }
                                
                                else { //they do have a profile image -> display it
                                    ZStack {
                                        KFImage(URL(string: userVM.localProfileImageUrl))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 125.0, height: 125.0, alignment: .center)
                                            .clipShape(Circle())
                                    }//ZStack
                                }
                                

                            } //if the user has not picked image
                            
                            else { //user has picked a new image
                               
                                
                                controls.pickedImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 125.0, height: 125.0, alignment: .center)
                                    .clipShape(Circle())
                                
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




// this button sends user info to databse
//                //To Do -- make this button a navigation link that sends user back to the main profile
//                                Button(action: {
//
//                                    let userId = userVM.localUserId
//
//                                    //update values of my_user
//                                    userVM.update_user_info(userId: userId, company_name: username, location_served: locationServe, bio: shortBio, profileImageData: ProfImageData, onError: { errorMessage in
//                                        print("Update user error: \(errorMessage)")
//                                    })
//
//
//
//                                }){
//                                    Text("Send a user to our database")
//                                }
//                                .padding()
//                                .foregroundColor(.white)
//                                .background(Color.red)
//                                .cornerRadius(20)
