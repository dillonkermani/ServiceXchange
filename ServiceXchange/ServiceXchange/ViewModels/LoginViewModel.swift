

import Foundation
import FirebaseAuth
import Firebase
//import FirebaseStorage
import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    
    var errorString = ""
    var errorTitle = ""
    var errorDismiss = ""
    
    @Published var showAlert: Bool = false
    
    func signup() {
        
        //AuthService.signupUser(firstName: firstName, lastName: lastName, email: email, password: password, onSuccess: completed, onError: onError)
        
    }
    
    func signin() {
        
    }
    
    func clear() {
        firstName = ""
        lastName = ""
        phone = ""
        email = ""
        password = ""
        confirmPassword = ""
    }
}
