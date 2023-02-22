//
//  ProfileViewTest.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 2/21/23.
//

import SwiftUI




struct ProfileViewTest: View {
    

    
    var body: some View {
        
        VStack {
            ZStack{
                showDetailImage()
                    .padding(.top, -450)
                showProfileImage()
                    .padding(.top, -260)
               settingMenu()
                    .padding(.leading, 270)
                    .padding(.top, -400)
            }

          
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
    
    //make this a button and make it spin and drop down a menu
    //replace the settiung view with just this menu
    //change these things to navigation links -> that go to the appropriate pages
    func settingMenu() -> some View {
        return VStack {
            Menu {
                Button("Edit Profile", action: order)
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
    
    func settingButton() -> some View {
        return VStack {
            Button(action: {
                print("hello")
                
                //make dropdown menu
                
                
                //make spinnning animation
                
            }, label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 35,
                                  weight: .regular,
                                  design: .default))
                    .foregroundColor(.black)
                    .frame(width: 47, height: 47)
                    .background(.white)
                    .cornerRadius(40)
            })
        }
        
    }
    
    
    func settingLink() -> some View {
        return VStack {
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
    
    func showProfileImage() -> some View {
        return VStack {
            Image("blankprofile")
                .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 125.0, height: 125.0, alignment: .center)
                    .clipShape(Circle())
        }
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
    

    
    
}

struct ProfileViewTest_Previews: PreviewProvider {
    static var previews: some View {
        ProfileViewTest()
    }
}
