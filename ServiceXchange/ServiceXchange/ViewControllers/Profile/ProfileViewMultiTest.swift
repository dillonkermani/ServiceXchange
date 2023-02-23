//
//  ProfileViewMultiTest.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 2/23/23.
//

import SwiftUI

struct ProfileViewMultiTest: View {
    
    
    @EnvironmentObject var userVM: UserViewModel
    
    @Binding var user: User
    @Binding var thisUser: Bool
    
   //lets find out if the user persists or not using the user parameter that is passed in
    
    
   // @ObservedObject var listingVM : listingVM
    
    //update depending on if this user is being used or it is another user that is being used
//    @State var profileIm : String = "hi"
//    @State var backgroundIm : String = "hi"
//    @State var companyName : String = "hi"
//    @State var location : String  = "hi"
//    @State var starRating : Double = 0.0
    
    //look at how to acess data and ensure that it is passed in I guess
    
    @State var name : String = "hold"

    
    var body: some View {
        
        VStack {
            
            Text( name )
            
        }.onAppear {
            if thisUser {
                name = userVM.localCompanyName
            }
            else {
                name = user.firstName
            }
        }
        //let _ = print("this is user firstName ", user.firstName)
    }
}

//struct ProfileViewMultiTest_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileViewMultiTest()
//    }
//}
