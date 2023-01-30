

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth



class LoginViewModel: ObservableObject {
    
    
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phone: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    
    var errorString = ""
    var authResultString = ""
    
    
    func signin(onSuccess: @escaping(_ user: User) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().signIn(withEmail: self.email, password: self.password) { (authData, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    onError(error!.localizedDescription)
                    return
                }
                guard let userId = authData?.user.uid else { return }
                
                let firestoreUserId = Ref.FIRESTORE_DOCUMENT_USERID(userId: userId)
                firestoreUserId.getDocument { (document, error) in
                    if let dict = document?.data() {
                        guard let decoderUser = try? User.init(fromDictionary: dict) else {return}
                        onSuccess(decoderUser)
                    }
                }
            }
  
       }
    
    
    func signup(onSuccess: @escaping(_ user: User) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
                Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
                    if error != nil {
                        onError(error!.localizedDescription)
                        return
                    }
                    
                    guard let userId = authData?.user.uid else { return }
                                        
                    let firestoreUserRef = Ref.FIRESTORE_DOCUMENT_USERID(userId: userId)
                                        
                    let user = User.init(uid: userId, firstName: self.firstName, lastName: self.lastName, email: self.email)
                                                            
                    guard let dict = try? user.toDictionary() else {return}

                    firestoreUserRef.setData(dict) { (error) in
                        if error != nil {
                            onError(error!.localizedDescription)
                            return
                        }
                        onSuccess(user)
                    }
 
                }
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
