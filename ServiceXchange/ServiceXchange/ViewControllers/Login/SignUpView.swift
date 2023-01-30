//
//  SignUpView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI


struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var loginVM = LoginViewModel()
    
    @State var signupPressed = false
    @State var signinPressed = false
    
    var body: some View {
        VStack {
            ZStack {
                if signupPressed {
                    if signinPressed {
                        signinFields()
                    } else {
                        signupFields()
                    }
                    
                }
                signupSheet()
            }

            VStack {
                Text(signupPressed ? "" : "Already a User?")
                    .font(.system(size: 17))

                ChangingButton()
                    .padding(.bottom, 10)
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(signupPressed ? "" : "Not Now")
                        .font(.system(size: 20)).bold()
                        .foregroundColor(.black)
                        .underline()
                }

            }.offset(y: -30)
            .padding(.bottom, 30)
            
            
        }.ignoresSafeArea()
    }
    
    private func SignUpButton() -> some View {
        return Button {
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            withAnimation(.easeInOut(duration: 0.5)) {
                signupPressed.toggle()
                loginVM.clear()
            }
        } label: {
            ZStack {
                Rectangle()
                    .frame(width: 250, height: 50)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .shadow(color: .gray, radius: 5, x: 0, y: 0)
                    .overlay(
                        RoundedRectangle(cornerRadius: signupPressed ? 40 : 15)
                            .stroke(.black, lineWidth: 2)
                    )
                
                Text("Sign Up")
                    .font(.system(size: 25)).bold()
                    .foregroundColor(.black)
            }
        }
    }

    // Has 3 states: { "Sign In", "<-", and "checkmark" }
    private func ChangingButton() -> some View {
        return Button {
            withAnimation(.easeInOut(duration: 0.5)) {
                if !signupPressed {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        signinPressed.toggle()
                        signupPressed.toggle()
                    }
                } else if !signinPressed && (loginVM.firstName.isEmpty || loginVM.lastName.isEmpty || loginVM.email.isEmpty || loginVM.phone.isEmpty || loginVM.password.isEmpty || loginVM.confirmPassword.isEmpty){
                    signupPressed = false
                    loginVM.clear()
                } else if signinPressed && (loginVM.email.isEmpty || loginVM.password.isEmpty){
                    signupPressed = false
                    signinPressed = false
                    loginVM.clear()
                }else if signinPressed {
                    print("Sign In user")
                    loginVM.signin()
                } else {
                    print("Sign up user")
                    loginVM.signup()
                }
            }
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        } label: {
            
            if (!signinPressed && (loginVM.firstName.isEmpty || loginVM.lastName.isEmpty || loginVM.email.isEmpty || loginVM.phone.isEmpty || loginVM.password.isEmpty || loginVM.confirmPassword.isEmpty)) || (signinPressed && (loginVM.email.isEmpty || loginVM.password.isEmpty)) {
                
                ZStack {
                    Rectangle()
                        .frame(width: signupPressed ? 70 : 190, height: signupPressed ? 70 : 50)
                        .foregroundColor(signupPressed ? .gray.opacity(0.7) : CustomColor.sxcgreen)
                        .cornerRadius(signupPressed ? 35 : 15)
                        .shadow(color: .gray, radius: 5, x: 0, y: 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: signupPressed ? 35 : 15)
                                .stroke(.black, lineWidth: 1)
                        )
                    
                    Text(signupPressed ? "←" : "Sign In")
                        .font(.system(size: signupPressed ? 30 : 20)).bold()
                        .foregroundColor(.black)
                    
                }
            } else {
                ZStack {
                    Rectangle()
                        .frame(width: 80, height: 80)
                        .foregroundColor(CustomColor.sxcgreen)
                        .cornerRadius(40)
                        .shadow(color: .gray, radius: 5, x: 0, y: 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(.black, lineWidth: 1)
                        )
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 30)).bold()
                        .foregroundColor(.white)
                }
                
                
                
            }
        }
    }
    
    private func signupSheet() -> some View {
        return ZStack {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.2)
                .foregroundColor(CustomColor.sxcgreen)
                .cornerRadius(35)
                .shadow(color: .gray, radius: 5, x: 0, y: 0)
                    .overlay(
                            RoundedRectangle(cornerRadius: 35)
                                .stroke(.black, lineWidth: 1)
                        )
            
            Spacer()
            
            VStack {
                Image("sxc_app_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding(.top, UIScreen.main.bounds.height * 1.1 - UIScreen.main.bounds.height)
                Text("ServiceXchange")
                    .font(.system(size: 43)).bold()
                    .padding(.bottom, 5)
                Text("Your Services, All in One Place")
                    .font(.system(size: 20)).bold()
                Spacer()
                Text("(Full App Access)")
                    .font(.system(size: 17))
                SignUpButton()
                    .padding(.bottom, 30)
                
                
            }
            
            
        }.offset(y: signupPressed ? -UIScreen.main.bounds.height : -30)
    }
    
    private func signupFields() -> some View {
        return ZStack {
            VStack {
                HStack {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .padding([.top, .bottom], 75)
                }
                HStack {
                    loginTextField(title: "First Name", text: $loginVM.firstName, width: 140, height: 40)
                    loginTextField(title: "Last Name", text: $loginVM.lastName, width: 140, height: 40)
                }
                loginTextField(title: "Email", text: $loginVM.email, width: 310, height: 40)
                    .keyboardType(.emailAddress)
                loginTextField(title: "Phone (recommended)", text: $loginVM.phone, width: 310, height: 40)
                    .keyboardType(.phonePad)
                passwordTextField(title: "Password", text: $loginVM.password, width: 310, height: 40)
                passwordTextField(title: "Confirm Password", text: $loginVM.confirmPassword, width: 310, height: 40)
                
                Spacer()
                
            }
            
        }
    }
    
    private func signinFields() -> some View {
        return ZStack {
            VStack {
                HStack {
                    Text("Sign In")
                        .font(.largeTitle)
                        .padding([.top, .bottom], 75)
                }
                loginTextField(title: "Email", text: $loginVM.email, width: 310, height: 40)
                    .keyboardType(.emailAddress)
                passwordTextField(title: "Password", text: $loginVM.password, width: 310, height: 40)
                    .padding(.bottom, 40)
                
                Button {
                    print("Forgot Password Pressed")
                } label: {
                    Text("Forgot Username or Password?")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                        .underline()
                }

                
                Spacer()
                
            }
            
        }
    }
    
    
    
    
    
    

}
  




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
