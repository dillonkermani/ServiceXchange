//
//  SignUpView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI


struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.2)
                    .foregroundColor(CustomColor.sxcgreen)
                    .cornerRadius(35)
                
                Spacer()
                
                VStack {
                    Image("sxc_app_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .padding(.top, UIScreen.main.bounds.height * 1.1 - UIScreen.main.bounds.height)
                    Text("ServiceXchange")
                        .font(.system(size: 50)).bold()
                        .padding(.bottom, 5)
                    Text("Your Services, All in One Place")
                        .font(.system(size: 20)).bold()
                    Spacer()
                    Text("(Full App Access)")
                        .font(.system(size: 20)).bold()
                    SignUpButton()
                        .padding(.bottom, 30)
                    
                    
                }
                
                
            }
            .padding(.bottom)
            Text("Already a User?")
                .font(.system(size: 20)).bold()
            
            SignInButton()
                .padding(.bottom, 30)
            
            
        }.ignoresSafeArea()
    }
    
    private func SignUpButton() -> some View {
        return Button {
            print("")
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width / 1.3, height: UIScreen.main.bounds.width / 6)
                    .foregroundColor(.white)
                    .cornerRadius(35)
                Text("Sign Up")
                    .font(.system(size: 40)).bold()
                    .foregroundColor(.black)
            }
        }
    }

    private func SignInButton() -> some View {
        return Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width / 1.7, height: UIScreen.main.bounds.height / 17)
                    .foregroundColor(CustomColor.sxcgreen)
                    .cornerRadius(35)
                Text("Sign In")
                    .font(.system(size: 30)).bold()
                    .foregroundColor(.black)
            }
        }
    }

}
    


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
