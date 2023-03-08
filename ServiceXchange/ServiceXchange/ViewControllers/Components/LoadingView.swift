//
//  ShimmerPlaceHolder2.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/13/23.
//

import SwiftUI

struct LoadingView: View {
    @State var opacity = 0.3
    let cycleTime = 3.0
    let maxOpacity = 0.6
    let color = Color(hue: 308, saturation: 0.05, brightness: 0.3)
    var body: some View {
        ZStack {
            Rectangle()
               
                .opacity(self.opacity)
                .animation(
                    Animation.easeIn(duration: self.cycleTime / 2)
                        .repeatForever(autoreverses: true),
                    value: opacity)
                .onAppear(perform: {self.opacity = self.maxOpacity})
               // .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2.3)
                //.cornerRadius(17)

            
        }.scaledToFit()
    }
}

struct LoadingViewParent<V: View>: View {
    var child: () -> V
    var body: some View {
        ZStack {
            LoadingView()
            child()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            LoadingView()
                .cornerRadius(20)
                .padding()
            LoadingViewParent {
                LoadingView()
                    .cornerRadius(20)
                    .padding()
            }
                .cornerRadius(20)
                .padding()
        }
        
    }
}
