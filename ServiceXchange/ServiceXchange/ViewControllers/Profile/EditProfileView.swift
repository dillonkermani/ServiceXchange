//
//  EditProfileView.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 2/15/23.
//

import SwiftUI


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
    
    
    
    var body: some View {
        ZStack {

            VStack {

                
                //add the profile image button thing
                addProfilePhoto()

                underlinedTextField(title: "company name", text: $username, width: 310, height: 20, color: CustomColor.sxcgreen)
                underlinedTextField(title: "location served", text: $locationServe, width: 310, height: 40, color: CustomColor.sxcgreen)
                underlinedTextField(title: "short bio", text: $shortBio, width: 310, height: 40, color: CustomColor.sxcgreen)
                
                //this button sends user info to databse
                //does not yet include sending the profile image
                Button(action: {
                    
                    //get the users information in the form of a unique stucture
                    //let userId = session.userSession!.userId
                    
                    let userId = userVM.localUserId
                    
                    //update values of my_user
                    userVM.update_user_info(userId: userId, company_name: username, location_served: locationServe, bio: shortBio, profileImageData: ProfImageData, onError: { errorMessage in
                        print("Update user error: \(errorMessage)")
                    })
                    
                   // print("in profile view before button pressed localImUrl: \(session.localProfileImageUrl)")
                    
                    //now can update the sessionStore variables here
                    //self.session.localProfileImageUrl = userVM.localProfileImageUrl
                    // !!! this is happening before the the userVM is updating in the above function
                    //session.updateLocal(profString: userVM.localProfileImageUrl)
                    
                    //print("in profile view after button pressed localImUrl: \(session.localProfileImageUrl)")
                    //print("in createView localCompanyName is: ", userVM.localCompanyName)
                    
                    //okay so I think the we have to only create one userviewModel struct --> duh and pass it between views
                    
                    //update our local user profile image data
                    //UserVM.localProfileImageUrl = ProfImageData
                    //session.refreshUser()

                    
                }){
                    Text("Send a user to our database")
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(20)
                
            }
        }
    } //ZStack
    
    
    private func addProfilePhoto() -> some View {
       return ZStack {
            //ScrollView {
                VStack {
                    
                        // create circlar button that once tapped on propts you to change user profile image
                    
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            controls.pickedImageType = "card"
                            controls.showImagePicker = true
                        }) {
                            if controls.pickedImage == Image("user-placeholder") {
                                ZStack {
                                    Circle()
                                        .fill(CustomColor.sxcgreen)
                                        .frame(width: 100, height: 100)
                                    Text("Add Image")
                                        .foregroundColor(.white)
                                }
                            } else {
                               
                                
                                controls.pickedImage
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(100)
                                
                            }
                        }
                        //.padding(35)
                        //Spacer()
                    

                    
                    
                }
            //}
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
