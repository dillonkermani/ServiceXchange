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
                    
                    Rectangle()
                }
                Spacer()
                VStack{
                    Rectangle()
                        .foregroundColor(Color.black.opacity(0.0))
                    
                    Image("blankprofile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        
                    Rectangle()
                    
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
