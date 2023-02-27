//
//  ProfileMakeMenuNav.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 2/25/23.
//

import SwiftUI

struct ProfileMakeMenuNav: View {
       @State var navigateTo: AnyView?
        @State private var isActive = false
    
    @State private var readyToNavigate : Bool = false
    
        var body: some View {

            VStack {
                //settingMenu3()
                //saveChangesButton()
                //saveChangesLink()
                saveChangesNav2()
            }
 
    
        }
    
    
    
    private func saveChangesLink() -> some View{
        
        VStack {
                      Button {
                          //Code here before changing the bool value
                          let _ = print("button pressed")
                          readyToNavigate = true
                      } label: {
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
                                      .stroke(Color.black, lineWidth: 5)
                              )
                      }
                  }
        //.navigationTitle("Save Changes")
                   .navigationDestination(isPresented: $readyToNavigate) {
                      ProfileView() //still thinks that we are in the profile view I guess maybe do this a different way
                  }
        
    }
    
//    private func customBack() -> some View {
//        
//    }
//    
    private func saveChangesNav2() -> some View {
        return VStack {
            NavigationLink(destination: HomeView(), label: {
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
                            .stroke(Color.black, lineWidth: 5)
                            .frame(width: 250, height: 70)
                    )
            }).simultaneousGesture(TapGesture().onEnded{
//                let userId = userVM.localUserId
//                userVM.update_user_info(userId: userId, company_name: username, location_served: locationServe, bio: shortBio, profileImageData: ProfImageData, backgroundImageData: backgroundImageData, onError: { errorMessage in
//                    print("Update user error: \(errorMessage)")
//                })
//                //print("hello")
                
                
                print("hello")
            })
        }
    }
    
    private func saveChangesButton() -> some View{
        return VStack {
            Button(action: {
                let _ = print("button pressed")
                
            },
              label: {
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
                            .stroke(Color.black, lineWidth: 5)
                    )
            })
        }
        
    }
    
    
    private func settingMenu3() -> some View{
        return NavigationView {
            Menu {
                Button("edit profile") {
                    navigateTo = AnyView(EditProfileView())
                    self.isActive = true
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






struct ProfileMakeMenuNav_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMakeMenuNav()
    }
}
