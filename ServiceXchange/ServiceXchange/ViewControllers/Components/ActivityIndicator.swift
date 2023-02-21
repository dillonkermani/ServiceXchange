import Foundation
import SwiftUI

struct ActivityIndicator: View {
    
    @Binding var isShowing: Bool
    @State private var isAnimating: Bool = false
    
    var body: some View {
        if isShowing {
            GeometryReader { (geometry: GeometryProxy) in
                ZStack {
                    Rectangle()
                        .frame(width: geometry.size.width*1.3, height: geometry.size.height*1.3)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: .gray, radius: 5, x: 0, y: 0)
                        
                    ForEach(0..<5) { index in
                        Group {
                            Circle()
                                .frame(width: geometry.size.width / 5, height: geometry.size.height / 5)
                                .scaleEffect(calcScale(index: index))
                                .offset(y: calcYOffset(geometry))
                        }.frame(width: geometry.size.width, height: geometry.size.height)
                            .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
                            .animation(Animation
                                .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
                                .repeatForever(autoreverses: false), value: isAnimating)
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .onAppear {
                self.isAnimating = true
            }
            
        }
    }
    
    func calcScale(index: Int) -> CGFloat {
        return (!isAnimating ? 1 - CGFloat(Float(index)) / 5 : 0.2 + CGFloat(index) / 5)
    }
    
    func calcYOffset(_ geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width / 10 - geometry.size.height / 2
    }
    
}
