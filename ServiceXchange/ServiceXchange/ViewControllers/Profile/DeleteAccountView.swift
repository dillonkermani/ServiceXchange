//
//  DeleteAccountView.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 3/7/23.
//

import SwiftUI

enum ActiveAlert2 {
    case deleteProfile
}

struct ProfileViewMultiTestControls {
    var deleteClicked = false
    var showAlert = false
    var activeAlert2: ActiveAlert2 = .deleteProfile
    var savePressed = false
}

struct DeleteAccountView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var controls = ProfileViewMultiTestControls()
    
    @EnvironmentObject var userVM: UserViewModel
    @StateObject var loginVM = LoginViewModel()
    
    @State var thisUserProfile = false
    @State var passwordInput: String = ""
 
    var body: some View {
        
        VStack {
            signInFields()
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
        .alert(isPresented: $controls.showAlert) {
                return Alert(title: Text("Delete Account?"), message: Text("Warning: This action cannot be undone."), primaryButton: .destructive(Text("Delete")) {

                    //clear the local variables
                    Task {
                        await userVM.asyncClear()
                    }
                    //delete the account
                    userVM.reAuthUserAndDelete(userProvidedPassword: passwordInput)
                    
                }, secondaryButton: .cancel())

        }//.alert

    }

    private func signInFields() -> some View {
        return VStack {
                HStack {
                    Text("Enter Password to Delete account")
                        .font(.largeTitle)
                        .padding([.top, .bottom], 75)
                }
                passwordTextField(title: "Password", text: $passwordInput, width: 310, height: 40, color: loginVM.password.isEmpty ? .black : CustomColor.sxcgreen)
                    .padding(.bottom, 40)
                
                Button {
                    controls.activeAlert2 = .deleteProfile
                    controls.showAlert.toggle()
                   
                } label: {
                    Text("Delete Account")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                        .underline()
                }
                .padding(20)
               
                
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
    } //some view
 
}

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountView()
    }
}
