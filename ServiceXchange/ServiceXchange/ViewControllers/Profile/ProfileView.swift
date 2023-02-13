//
//  ProfileView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct CreateProfileControls {
    var pickedImageType = ""
    var showImagePicker = false
    var pickedImage = Image("user-placeholder")
    var width = (UIScreen.main.bounds.width * 0.43)
    var height = (UIScreen.main.bounds.width * 0.43)
    var showAlert = false
    var alertMessage = ""
}




struct ProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode // Allows us to dismiss views.
    @EnvironmentObject var session: SessionStore // Stores user's login status.
    
    //@ObservedObject var listingVM = ListingViewModel() //this is a reference to the listing class metadata I think
                                                       //create one for profile later
                                                       //gotta make a new view model for the user profile I think
    @ObservedObject var UserVM = UserViewModel()
    
    
    @State var controls = CreateProfileControls() //some control variables for the image picker now given for
    
    
    //these are all my user variables (should I declair them differently or take them in differently)
    @State private var username: String = ""
    @State private var locationServe: String = ""
    @State private var shortBio: String = ""
    @State private var service: String = ""
    @State var ProfImageData = Data()
    
    
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    //account settings icon --> find the settings icon fo swift
                    //I want in top right corner
                    //text, Welcome back NAME --> find out how to get the nam of the person
                    if session.userSession != nil {
                        Text("Welcome, \(session.userSession!.firstName)")
                            .font(.system(size: 30,
                                          weight: .regular,
                                          design: .default))
                            .padding(.trailing, 30)
                    }
                    
                    
                    
                    
                    //will go to an account settings page once I make that page and figure out what in the
                    //world would be included in it
                    NavigationLink(destination: SettingsView(), label: {
                        Image(systemName: "gear")
                        
                            .font(.system(size: 35,
                                          weight: .regular,
                                          design: .default))
                            .foregroundColor(.black)
                            .frame(width: 50, height: 50)
                            .background(CustomColor.sxcgreen)
                            .cornerRadius(40)
                    })
                }
                
                ScrollView {
                    ButtonStack()
                }
                
            }.alert(isPresented: $controls.showAlert) {
                
                Alert(title: Text(controls.alertMessage),
                    message: Text(""),
                    dismissButton: Alert.Button.default(
                        Text("OK"), action: {
                            
                        }
                    )
                )
            }
        }
    }
    
    private func ButtonStack() -> some View {
        return VStack(spacing: 30) {
            addProfilePhoto()
                .padding(.bottom, 20)

            
            Spacer()
            
            //edit service provider profile button --> does this become a create listing once you have done it?
            NavigationLink(destination: CreateView(), label: {
                CustomProfileButtonView(title: "View Provider Account", foregroundColor: .white, backgroundColor: CustomColor.sxcgreen)
            })
            
            //saved listings --> goes to a page that has the saved listing posts
            NavigationLink(destination: SavedListingsView(), label: {
                CustomProfileButtonView(title: "Saved Listings", foregroundColor: .white, backgroundColor: .blue.opacity(0.3))
            })
            

            Button {
                session.logout()
                controls.alertMessage = "Sucessfully Logged Out"
                controls.showAlert.toggle()
            } label: {
                CustomProfileButtonView(title: "Sign Out", foregroundColor: .red, backgroundColor: .gray.opacity(0.5))

            }
        }
            
            
            
        
    }
    
    private func CustomProfileButtonView(title: String, foregroundColor: Color, backgroundColor: Color) -> some View {
        return ZStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width / 1.3, height: 50)
                .shadow(radius: 5)
                .foregroundColor(backgroundColor)
            Text(title)
                .font(.system(size: 17)).bold()
                .foregroundColor(foregroundColor)
        }.cornerRadius(30)
    }
    

    //get help to have less space betwen photo and whatnot
    private func CreateView() -> some View {
        return ZStack{

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
                    let userId = session.userSession!.userId
                    
                    //update values of my_user
                    UserVM.update_user_info(userId: userId, company_name: username, location_served: locationServe, bio: shortBio, profileImageData: ProfImageData, onError: { errorMessage in
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
        }
    }
    
    private func SettingsView() -> some View {
        return ZStack{
            VStack{
                Text("Settings").font(.subheadline).bold()
                
                
            }
        }
    }
    private func SavedListingsView() -> some View {
        return ZStack{
            
            VStack{
                Text("Saved Listings").font(.subheadline).bold()
            }
        }
    }
    
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


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

