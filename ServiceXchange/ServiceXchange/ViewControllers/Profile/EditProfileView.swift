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

struct CreateDescriptiveControls {
    var pickedImageType = ""
    var showImagePicker = false
    var pickedImage = Image("user-placeholder")
    var width = (UIScreen.main.bounds.width * 0.43)
    var height = (UIScreen.main.bounds.width * 0.43)
    var showAlert = false
    var alertMessage = ""
}



struct EditProfileView: View {
    
    @EnvironmentObject var userVM: UserViewModel
    
    @State var controls = CreateProfileControls()
    @State var controlsDesc = CreateDescriptiveControls()
    
    @Environment(\.presentationMode) var presentationMode
    
    //state varibles
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var username: String = ""
    @State private var locationServe: String = ""
    @State private var shortBio: String = ""
    @State private var service: String = ""
    @State var ProfImageData = Data()
    @State var backgroundImageData = Data()
    
    //varibles that autofill the edit prompts if you already have somthing in that variable
    @State var companyNameTitle: String = ""
    @State var shortBioTitle: String = ""
    @State var locationServeTitle: String = ""
    
    
    @State private var userToPass : User = User(
        userId: "",
        firstName: "",
        lastName: "",
        email: "",
        isServiceProvider: false,
        listings: []
    )
    @State private var thisUser : Bool = true
    
    
    var body: some View {
        //testing my newButtons
        ZStack {
            changeBackgroundIm()
                .offset(y: Constants.screenHeight * -0.27)
            
            changeProfileIm()
                .offset(y: Constants.screenHeight * -0.15)
            VStack{
                textEditFields()
                    .offset(y: Constants.screenHeight * 0.15)
                    .padding(.top, 30)
                
                saveChangesButton()
                    .offset(y: Constants.screenHeight * 0.15)
                
            }//VStack
            
        }//ZStack
        .onAppear{
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
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 17)).bold()
                        }.foregroundColor(.black)
                    }
                    
                }
            }
        }
        .onAppear {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }

            
    } //view structure

    func saveChangesButton() -> some View {
        return VStack {
            Button(action: {
                let userId = userVM.localUserId
                userVM.update_user_info(
                    userId: userId,
                    firstName: firstName,
                    lastName: lastName,
                    company_name: username,
                    location_served: locationServe,
                    bio: shortBio,
                    profileImageData: ProfImageData,
                    backgroundImageData: backgroundImageData,
                    onError: { errorMessage in
                      print("Update user error: \(errorMessage)")

                    }
                )//userVM.update_user_info
                
                //dismiss current view
                presentationMode.wrappedValue.dismiss()
                
            }, label: {
                HStack {
                    Spacer()
                    Text("Save Changes")
                        .font(.system(size: 17))
                        .padding(15)
                    Spacer()
                    
                }
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(17)
                .overlay(
                    RoundedRectangle(cornerRadius: 17)
                        .stroke(.black, lineWidth: 2)
                )
                .padding(15)
            })//button
        }//VStack
    }
    
    func textEditFields() -> some View {
        return VStack {
            
            HStack {
                underlinedTextField(title: "First: " + userVM.localFirstName, text: $firstName, width: 137, height: 20, color: .black)
                
                underlinedTextField(title: "Last: " + userVM.localLastName, text: $lastName, width: 137, height: 20, color: .black)
            }
            //.padding(.top, 10)
            
            underlinedTextField(title: "Company: " + companyNameTitle, text: $username, width: 310, height: 20, color: .black)
                
            underlinedTextField(title: "Description: " + shortBioTitle, text: $shortBio, width: 310, height: 40, color: .black)
            
            underlinedTextField(title: "Location: " + locationServeTitle, text: $locationServe, width: 310, height: 10, color: .black)
        }
    }//textFields function
    
    

    func changeBackgroundIm() -> some View {
        
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let width = screenWidth - 20
        let height = screenHeight * 0.25
        
        return ZStack {
            
            if controlsDesc.pickedImage == Image("user-placeholder") {
                
                //if user does not have a profile picture yet
                if userVM.localDescriptiveImageStr == "" {
                    ProfileBackground(imageStr: "")
                }
                else { //they do have a profile image -> display it
                    
                    ProfileBackground(imageStr: userVM.localDescriptiveImageStr)
                }
                

            } //if the user has not picked image
            
            else { //user has picked a new image
                controlsDesc.pickedImage
                    .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width, height: height, alignment: .top)
                        .clipShape(Rectangle())
                        .cornerRadius(20)
            }
            Button(action: {
                //want to flip the showing image picker so that the sheet is shown
                print("button pressed")
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                controlsDesc.pickedImageType = "card"
                controlsDesc.showImagePicker = true
            }, label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30,
                                  weight: .regular,
                                  design: .default))
                    .foregroundColor(.black)
                    .background(.white)
                    .clipShape(Circle())
            })
            .offset(y: screenHeight * 0.10)
            .offset(x: screenWidth * 0.40)
            
            
        }
        .sheet(isPresented: $controlsDesc.showImagePicker, content: {
            ImagePicker(showImagePicker: $controlsDesc.showImagePicker, pickedImage: $controlsDesc.pickedImage, imageData: $backgroundImageData, sourceType: .photoLibrary)
                
        })//.sheet
        
        
    }//changeProfileIm function
    
    
    func changeProfileIm() -> some View {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let profileRad: CGFloat = screenWidth * 0.30
        
        return ZStack {
            
            if controls.pickedImage == Image("user-placeholder") {
                
                //if user does not have a profile picture yet
                if userVM.localProfileImageUrl == "" {
                    ProfileImage(imageStr: "", diameter: profileRad)
                }
                
                else { //they do have a profile image -> display it
                    ProfileImage(imageStr: userVM.localProfileImageUrl, diameter: profileRad)
                }

            } //if the user has not picked image
            
            else { //user has picked a new image
               
                
                controls.pickedImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 125.0, height: 125.0, alignment: .center)
                    .clipShape(Circle())
                
            }
 
            //button that pulls up the image picker
            Button(action: {
                //want to flip the showing image picker so that the sheet is shown
                print("button pressed")
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                controls.pickedImageType = "card"
                controls.showImagePicker = true
            }, label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 30,
                                  weight: .regular,
                                  design: .default))
                    .foregroundColor(.black)
                    .background(.white)
                    .clipShape(Circle())
            })
            .offset(y: screenHeight * 0.06)
            .offset(x: screenWidth * 0.09)
        }
        .sheet(isPresented: $controls.showImagePicker, content: {
            ImagePicker(showImagePicker: $controls.showImagePicker, pickedImage: $controls.pickedImage, imageData: $ProfImageData, sourceType: .photoLibrary)
                
        })
        
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
 
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
            .environmentObject(UserViewModel())
    }
}



