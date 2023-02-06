//
//  ShimmerPlaceholderView.swift
//  Unibui_App
//
//

import SwiftUI

public struct ShimmerPlaceholderView: View {
    
    @State private var opacity: Double = 0.25
    var width: CGFloat
    var height: CGFloat
    var cornerRadius: CGFloat
    var animating: Bool?
    
    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.5))
            .frame(width: width, height: height)
            .opacity(opacity)
            .transition(.opacity)
            .animation(animating ?? true ? Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true) : .none)
            .onAppear {
                withAnimation {
                    opacity = 1.0
                }
            }
    }
}

public struct ShimmerPlaceholderView_Previews: PreviewProvider {
    public static var previews: some View {
        ZStack {
            Text("Hello")
            if 1 == 1 {
                ShimmerPlaceholderView(width: UIScreen.main.bounds.width - 32, height: (UIScreen.main.bounds.width - 32) * 1.5, cornerRadius: 10)
            }
        }
    }
}
