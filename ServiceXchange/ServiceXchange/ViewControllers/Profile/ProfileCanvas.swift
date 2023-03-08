//
//  ProfileCanvas.swift
//  ServiceXchange
//
//  Created by colton jeffrey on 3/8/23.
//

import SwiftUI

struct ProfileCanvas: View {
    var body: some View {
        VStack{
            ZStack {
                VStack {
                    Image("sunsetTest")
                        .resizable()
                    //.aspectRatio(contentMode: .fit)
                        .cornerRadius(20)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 30)
                    
                    
                }
                Spacer()
                VStack{
                    
                    Image("blankprofile")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .offset(y: UIScreen.main.bounds.height / 6)
                        
                    //Rectangle()
                      //  .foregroundColor(.green)
                    Text("Dillon Kermani")
                
                }
            }
            
            //Rectangle()
              //  .aspectRatio(contentMode: .fit)
            
            Rectangle()
                .aspectRatio(contentMode: .fit)
//
//            Rectangle()
//                .aspectRatio(.fill )
//
//            Text("hello")
//
//
            
            
            
            
            
            
        }
    }
}

struct ProfileCanvas_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCanvas()
    }
}
