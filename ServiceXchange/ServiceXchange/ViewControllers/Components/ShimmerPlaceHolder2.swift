//
//  ShimmerPlaceHolder2.swift
//  ServiceXchange
//
//  Created by Sam Wortzman on 2/13/23.
//

import SwiftUI

struct ShimmerPlaceHolder2<Content: View>: View {
    @State var opacity = 0.25
    var child: () -> Content = EmptyView.init as 
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray)
                .opacity(self.opacity)
                .animation(
                    Animation.easeIn(duration: 1.0)
                        .repeatForever(autoreverses: true),
                    value: opacity)
                .onAppear(perform: {self.opacity = 0.75})
            
            child()
            
        }
    }
}

struct ShimmerPlaceHolder2_Previews: PreviewProvider {
    static var previews: some View {
        ShimmerPlaceHolder2() {
            Rectangle()
        }
    }
}
