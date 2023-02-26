//
//  ProfileViewMultiTest.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 2/23/23.
//

import SwiftUI
import Kingfisher

struct ProfileViewMultiTest: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var userVM: UserViewModel
    
    @Binding var user: User
    @Binding var thisUser: Bool
    

    
    @State var name : String = "hold"

    
    //
     @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>


     
     //
    
    @State var navigateTo: AnyView?
     @State private var isActive = false

    
    var body: some View {
        
        VStack {
            
            imageOverlayTop(thisUserProfile: thisUser, user: user)
            
            //Text( name )
            //let _ = print("name in testView: ", name )
            //settingMenu3()
            
            
            NavigationLink(destination: ProfileMakeMenuNav(), label: {Image(systemName: "gearshape.fill")
                    .font(.system(size: 35,
                                  weight: .regular,
                                  design: .default))
                    .foregroundColor(.black)
                    .frame(width: 47, height: 47)
                    .background(.white)
                .cornerRadius(40)
                
            })
//
   
            
        }.onAppear {
            
            //initailize the local user variables if you have not already
            if (userVM.initialized == false && session.userSession != nil){
                userVM.updateLocalUserVariables(user: session.userSession!)
            }//if uninitailized (this can get moved if we want info in other pages (maybe tabview icon?))
            
        
            
            
            if thisUser {
                user = userVM.skUser
                let _ = print ("userVM.localCompanyName: ", userVM.localCompanyName)
                name = userVM.localCompanyName
            }
            else {
                let _ = print("user.firstname = ", user.firstName)
                name = user.firstName
            }
            
        }.toolbar(.hidden)
      
    }
     
    
    
    //returns the detail image bahind profile and either setting or message icon
    private func imageOverlayTop(thisUserProfile : Bool, user: User) -> some View {
        return  ZStack{
            
            let image1 = (user.descriptiveImageStr ?? "sunsetTest")
            showDetailImage(image: image1)
                 .padding(.top, -390)
            
            let image = (user.profileImageUrl ?? "blankprofile")
            showProfileImage(image: image)
                 .padding(.top, -205)
            
            
            if thisUserProfile {
                settingMenu3()
                     .padding(.leading, 270)
                     .padding(.top, -320)
            }
            else {
                messageNavButton()
                    .padding(.leading, 270)
                    .padding(.top, -320)
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
                Button("sign out"){ //we have implemented this go back and put it in
                    print("not implemented")
                }
                Button("delete account"){
                    print("not implemented")
                }
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
            }
            .background(
                //do we care if this is about to go away or something?
                NavigationLink(destination: self.navigateTo , isActive: $isActive) {
                    EmptyView()
                })
        }
    }

    
}




//returns the detail image bahind profile and either setting or message icon
func imageOverlayTop(thisUserProfile : Bool, user: User) -> some View {
    return  ZStack{
        
        let image1 = (user.descriptiveImageStr ?? "sunsetTest")
        showDetailImage(image: image1)
             .padding(.top, -390)
        
        let image = (user.profileImageUrl ?? "blankprofile")
        showProfileImage(image: image)
             .padding(.top, -205)
        
        
        if thisUserProfile {
            settingMenu()
                 .padding(.leading, 270)
                 .padding(.top, -320)
        }
        else {
            messageNavButton()
                .padding(.leading, 270)
                .padding(.top, -320)
        }
    }
  
}


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

//make this a button and make it spin and drop down a menu
//replace the settiung view with just this menu
//change these things to navigation links -> that go to the appropriate pages
func settingMenu() -> some View {
    return VStack {
        Menu {
            NavigationLink(destination: MessagesView(), label: {
                Label("Send Message", systemImage: "envelope")
            })
            NavigationLink("Edit Profile", destination: EditProfileView())
            //Button("Edit Profile", action: order)
            Button("Change Password", action: order)
            Button("Saved Listings", action: order)
            Button("History", action: order)
            Button("sign out", action: order)
        } label: {
            Image(systemName: "gearshape.fill")
                .font(.system(size: 35,
                              weight: .regular,
                              design: .default))
                .foregroundColor(.black)
                .frame(width: 47, height: 47)
                .background(.white)
                .cornerRadius(40)
        }
    }
    
}







func order() {}

func showProfileImage(image : String) -> some View {
    return VStack {
        
        
        
        if image != "blankprofile"  && image != ""{
            KFImage(URL(string: image))
            //Image("blankprofile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 125.0, height: 125.0, alignment: .center)
                .clipShape(Circle())
        }
        else {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 125.0, height: 125.0, alignment: .center)
                .clipShape(Circle())
        }
    }
}

func showDetailImage(image : String) -> some View {
    return VStack {
        
        if image == "" || image == "sunsetTest"{
            Image("sunsetTest")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 400.0, height: 250.0, alignment: .top)
                .clipShape(Rectangle())
        }
        else {
            KFImage(URL(string : image))
            //Image("sunsetTest")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 400.0, height: 250.0, alignment: .top)
                .clipShape(Rectangle())
        }
    }
}


//TODO make the back arrow custom button -> steal from dillon mawhhahaha
//func backArrow() -> some View {
//    return VStack {
//        Button(action: {
//            self.presentationMode.wrappedValue.dismiss()
//        }) {
//            HStack {
//                Image("ic_back") // set image here
//                    .aspectRatio(contentMode: .fit)
//                    .foregroundColor(.white)
//                Text("Go back")
//            }
//        }
//
//    }
//}



//struct ProfileViewMultiTest_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileViewMultiTest()
//    }
//}
