//
//  SignUpView.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/25/23.
//

import SwiftUI

struct LoginViewControls {
    var showPassword1 = false
    var showPassword2 = false
    var showPassword3 = false

}

struct LoginView: View {
    
    
    //@EnvironmentObject var session: SessionStore
    @Environment(\.presentationMode) var presentationMode
     
    
    @StateObject var loginVM = LoginViewModel()
    
    
    @State var signupPressed = false
    @State var signinPressed = false
    
    @State var showAlert = false
    @State var alertMessage = ""
    @State var dismissLoginView = false
    
    @State var controls = LoginViewControls()
    
    var body: some View {
        VStack {
            ZStack {
                if signupPressed {
                    ScrollView {
                        if signinPressed {
                            signinFields()
                        } else {
                            signupFields()
                        }
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
            .alert(isPresented: $showAlert) {

                Alert(title: Text(alertMessage),
                    message: Text(""),
                    dismissButton: Alert.Button.default(
                        Text("OK"), action: {
                            if dismissLoginView {
                                presentationMode.wrappedValue.dismiss() // Dismiss LoginView
                            }
                            
                        }
                    )
                )
            }
    }
    
    private func SignUpButton() -> some View {
        return VStack {
            Button {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                withAnimation(.spring()) {
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
    }

    // Has 3 states: { "Sign In", "<-", and "checkmark" }
    private func ChangingButton() -> some View {
        return Button {
            withAnimation(.easeInOut(duration: 0.5)) {
                if !signupPressed {
                    withAnimation(.spring()) {
                        signinPressed.toggle()
                        signupPressed.toggle()
                    }
                } else if !signinPressed && (loginVM.firstName.isEmpty || loginVM.lastName.isEmpty || loginVM.email.isEmpty || loginVM.password.isEmpty || loginVM.confirmPassword.isEmpty){
                    signupPressed = false
                    loginVM.clear()
                } else if signinPressed && (loginVM.email.isEmpty || loginVM.password.isEmpty){
                    signupPressed = false
                    signinPressed = false
                    loginVM.clear()
                }else if signinPressed {
                    signupPressed = false
                    signinPressed = false
                    
                    // Sign In
                    loginVM.signin(onSuccess: {user in
                        alertMessage = "Successfully signed in to \(user.email.lowercased())"
                        showAlert.toggle()
                        print(alertMessage)
                        dismissLoginView = true
                    }, onError: {errorMessage in
                        alertMessage = errorMessage
                        showAlert.toggle()
                        print(alertMessage)
                    })
                } else {
                    // Sign Up
                    loginVM.signup(onSuccess: {user in
                        alertMessage = "Successfully Signed Up!"
                        showAlert.toggle()
                        print(alertMessage)
                        dismissLoginView = true
                    }, onError: {errorMessage in
                        alertMessage = errorMessage
                        showAlert.toggle()
                        print(alertMessage)
                        
                    })
                }
            }
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        } label: {
            
            if (!signinPressed && (loginVM.firstName.isEmpty || loginVM.lastName.isEmpty || loginVM.email.isEmpty || loginVM.password.isEmpty || loginVM.confirmPassword.isEmpty)) || (signinPressed && (loginVM.email.isEmpty || loginVM.password.isEmpty)) {
                
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
                    underlinedTextField(title: "First Name", text: $loginVM.firstName, width: 140, height: 40, color: loginVM.firstName.isEmpty ? .black : CustomColor.sxcgreen)
                    underlinedTextField(title: "Last Name", text: $loginVM.lastName, width: 140, height: 40, color: loginVM.lastName.isEmpty ? .black : CustomColor.sxcgreen)
                }
                underlinedTextField(title: "Email", text: $loginVM.email, width: 310, height: 40, color: loginVM.email.isEmpty ? .black : CustomColor.sxcgreen)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                underlinedTextField(title: "Phone (optional)", text: $loginVM.phone, width: 310, height: 40, color: loginVM.phone.isEmpty ? .black : CustomColor.sxcgreen)
                    .keyboardType(.phonePad)
                
                ZStack {
                    passwordTextField(title: "Password", text: $loginVM.password, width: 310, height: 40, color: loginVM.password.isEmpty ? .black : CustomColor.sxcgreen, showPassword: $controls.showPassword1)
                    HStack {
                        Spacer()
                        Button(action: {
                            controls.showPassword1.toggle()
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        }, label: {
                            Image(systemName: controls.showPassword1 ? "eye.slash.fill" : "eye.fill").font(.system(size: 16, weight: .regular))
                                .padding()
                                .foregroundColor(.black)
                        }).offset(x: -35)
                    }
                    
                }
                
                ZStack {
                    passwordTextField(title: "Confirm Password", text: $loginVM.confirmPassword, width: 310, height: 40, color: loginVM.confirmPassword.isEmpty ? .black : CustomColor.sxcgreen, showPassword: $controls.showPassword2)
                    HStack {
                        Spacer()
                        Button(action: {
                            controls.showPassword2.toggle()
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        }, label: {
                            Image(systemName: controls.showPassword2 ? "eye.slash.fill" : "eye.fill").font(.system(size: 16, weight: .regular))
                                .padding()
                                .foregroundColor(.black)
                        }).offset(x: -35)
                    }
                }
                
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
                underlinedTextField(title: "Email", text: $loginVM.email, width: 310, height: 40, color: loginVM.email.isEmpty ? .black : CustomColor.sxcgreen)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.none)
                ZStack {
                    passwordTextField(title: "Password", text: $loginVM.password, width: 310, height: 40, color: loginVM.password.isEmpty ? .black : CustomColor.sxcgreen, showPassword: $controls.showPassword3)
                    HStack {
                        Spacer()
                        Button(action: {
                            controls.showPassword3.toggle()
                            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                        }, label: {
                            Image(systemName: controls.showPassword3 ? "eye.slash.fill" : "eye.fill").font(.system(size: 16, weight: .regular))
                                .padding()
                                .foregroundColor(.black)
                        }).offset(x: -35)
                    }
                }
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
