//
//  ProfileViewMultiTest.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 2/23/23.
//

//my todo ---> make loading image while images change --> maybe a state variable ---> clean up my code

import SwiftUI
import FirebaseAuth

//enum ActiveAlert2 {
//    case deleteProfile
//}

//struct ProfileViewMultiTestControls {
//    var deleteClicked = false
//    var showAlert = false
//    var activeAlert2: ActiveAlert2 = .deleteProfile
//    var savePressed = false
//
//}

struct ProfileViewMultiTest: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var userVM: UserViewModel
    
    
    //@State var controls = ProfileViewMultiTestControls()
    
    @Binding var user: User
    @Binding var thisUser: Bool
    

    
    @State var name : String = "hold"
    @State var profile : String = "none"
    @State var background : String = "none"

    
    //
     @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>


     
     //
    
     @State var navigateTo: AnyView?
     @State private var isActive = false
    
    //@State var showSignIn: Bool = false
    
    var body: some View {
        
        
        if !thisUser {
        //if true {
        
        VStack {
            
            //how do I make this shit wait on a state variable?
            if !userVM.loadingData {
                imageOverlayTop(thisUserProfile: thisUser, user: user)
            }
            //let _ = print("profile image is (user) : ", user.profileImageUrl)
            //let _ = print("profile image is (userVM.skUser)", userVM.skUser.profileImageUrl)
            
        }.onAppear {
            
            //initailize the local user variables if you have not already
            if (userVM.initialized == false && session.userSession != nil){
                userVM.updateLocalUserVariables(user: session.userSession!)
            }//if uninitailized (this can get moved if we want info in other pages (maybe tabview icon?))
            
            if thisUser {
                if(!userVM.loadingData){
                    user = userVM.skUser
                }
                let _ = print ("userVM.localCompanyName: ", userVM.localCompanyName)
                name = userVM.localCompanyName
            }
            else {
                let _ = print("user.firstname = ", user.firstName)
                name = user.firstName
            }
            
        }//.toolbar(.hidden)
        // if !thisUser {
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
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
        // }//if not this user we need a back button
        
    }//if not this user
        
        else {
            VStack {
                
                //sends user to sign in fields if they delete account
                //NavigationLink(destination: ProfileViewTest(), isActive: self.$showSignIn) { EmptyView() }
                
                
                imageOverlayTopMine(thisUserProfile: thisUser, user: user)
                
                

            }.onAppear {
                
                //initailize the local user variables if you have not already
                if (userVM.initialized == false && session.userSession != nil){
                    userVM.updateLocalUserVariables(user: session.userSession!)
                }//if uninitailized (this can get moved if we want info in other pages (maybe tabview icon?))
                
                
                
                
                if thisUser {
                    user = userVM.skUser
                    let _ = print ("userVM.localCompanyName: ", userVM.localCompanyName)
                    name = userVM.localCompanyName
                    profile = userVM.localProfileImageUrl
                    background = userVM.localDescriptiveImageStr
                }
                else {
                    let _ = print("user.firstname = ", user.firstName)
                    name = user.firstName
                    profile = user.profileImageUrl ?? "blankprofile"
                    background = user.descriptiveImageStr ?? "sunsetTest"
                }
                
            }.toolbar(.hidden)
            
            
//                .alert(isPresented: $controls.showAlert) {
//
//                    //case .deleteProfile:
//                        return Alert(title: Text("Delete Account?"), message: Text("Warning: This action cannot be undone."), primaryButton: .destructive(Text("Delete")) {
//
//                            showSignIn = true
//
//                        }, secondaryButton: .cancel())
//
//                }//.alert
            
        }
        
        
    }//some view
     
    
    //figure out how to make it wait or show some kind of loading before proceeding to show the iamge
    private func imageOverlayTopMine(thisUserProfile : Bool, user: User) -> some View {
        return  ZStack{
            
            
            //let image1 = (user.descriptiveImageStr ?? "sunsetTest")
            // while background == "none" {}
            if userVM.localDescriptiveImageStr == "none"{
                showDetailImage(imageStr: "sunsetTest")
                    .padding(.top, -410)
            }
            else{
                showDetailImage(imageStr: userVM.localDescriptiveImageStr)
                    .padding(.top, -410)
            }
            
            if userVM.localProfileImageUrl == "none" {
                showProfileImage(imageStr: "blankprofile")
                    .padding(.top, -215)
            }
            else {
                //let image = (user.profileImageUrl ?? "blankprofile")
                showProfileImage(imageStr: userVM.localProfileImageUrl)
                    .padding(.top, -215)
            }
            
            if thisUserProfile {
                settingMenu3()
                     .padding(.leading, 270)
                     .padding(.top, -320)
            }
            else {
                messageNavButton()
                    .padding(.leading, 270)
                    .padding(.top, -150)
            }
        }
      
    }
    
    //returns the detail image bahind profile and either setting or message icon
    private func imageOverlayTop(thisUserProfile : Bool, user: User) -> some View {
        return  ZStack{
            
            
            let image1 = (user.descriptiveImageStr ?? "sunsetTest")
           // while background == "none" {}
            showDetailImage(imageStr: image1)
                 .padding(.top, -420)
            
            let image = (user.profileImageUrl ?? "blankprofile")
            showProfileImage(imageStr: image)
                 .padding(.top, -235)
            
            
            if thisUserProfile {
                settingMenu3()
                     .padding(.leading, 270)
                     .padding(.top, -320)
            }
            else {
                messageNavButton()
                    .padding(.leading, 270)
                    .padding(.top, -150)
            }
        }
      
    }//imageOverlayTop
    
    
    private func settingMenu3() -> some View{
       
        return VStack {
            Menu {
                Button("edit profile") {
                    navigateTo = AnyView(EditProfileView())
                    self.isActive = true
                }
                Button("sign out"){ //works but maybe look into a warning "are you sure you want to sign out?"
                    
                    session.logout()
                    //clear local user variables
                    userVM.clearLocalUserVariables()
                    
                    navigateTo = AnyView(HomeView())
                    self.isActive = true
                }
                
                
                Button("Delete Account2"){
                    navigateTo = AnyView(ProfileViewTest())
                    self.isActive = true
                }
                
//                Button(role: .none, action: {
//                    controls.activeAlert2 = .deleteProfile
//                    controls.showAlert.toggle()
//                }, label: {
//                    Label("Delete Profile", systemImage: "trash")
//                        .foregroundColor(.black)
//                })
                
                
                Button("History"){
                    print("not implemented")
                }
                Button("change password"){
                    print("not implemented")
                }
                Button("Saved Listigns"){
                    print("not implemented")
                }

                
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 35,
                                  weight: .regular,
                                  design: .default))
                    .foregroundColor(.black)
                    .frame(width: 47, height: 47)
                    .background(.white)
                    .cornerRadius(40)
            } //label
            .background(
                //do we care if this is about to go away or something?
                NavigationLink(destination: self.navigateTo , isActive: $isActive) {
                    EmptyView()
                }
                
            )//background
            
        }//VStack
    } //setting Menu 3

    
}



//navigation link that sends you to messaging view
//will have to change later to make it go right to a message with that person
func messageNavButton() -> some View {
    return VStack {
        //changethis later so that it navigates straight to
        //a message with that person
        NavigationLink(destination: MessagesView(), label: {
            Image(systemName: "paperplane")
                .font(.system(size: 35,
                              weight: .semibold,
                              design: .default))
                .foregroundColor(.black)
                .frame(width: 47, height: 47)
                .background(.clear)
                .cornerRadius(40)
        })
    }
}


//shows profile image as a circle
func showProfileImage(imageStr : String) -> some View {
    return VStack {
        
        if imageStr != "blankprofile"  && imageStr != ""{
            
            
            AsyncImage(url: URL(string:  imageStr)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 125.0, height: 125.0, alignment: .center)
                    .clipShape(Circle())
            } placeholder: {
                ShimmerPlaceholderView(width: 125, height: 125, cornerRadius: 0, animating: true)
            }
            
        }
        else {
            Image(imageStr)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 125.0, height: 125.0, alignment: .center)
                .clipShape(Circle())
        }
    }
}//showProfileImage


//show detail or backround image
func showDetailImage(imageStr : String) -> some View {
    return VStack {
        
        if imageStr == "" || imageStr == "sunsetTest"{
            Image("sunsetTest")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 400.0, height: 250.0, alignment: .top)
                .clipShape(Rectangle())
        }
        else {
            
            AsyncImage(url: URL(string:  imageStr)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 400, height: 250)
                    .clipShape(Rectangle())
            } placeholder: {
                ShimmerPlaceholderView(width: 400, height: 250, cornerRadius: 0, animating: true)
            }
            

        }
    }
}//showDetailImage





//struct ProfileViewMultiTest_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileViewMultiTest()
//    }
//}
