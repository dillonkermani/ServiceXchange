

import SwiftUI

func loginTextField(title: String, text: Binding <String>, width: CGFloat, height: CGFloat) -> some View {
    return TextField(title, text: text)
        .frame(width: width, height: height)
        .padding(.vertical, 10)
                    .overlay(Rectangle().frame(height: 2).padding(.top, 35).foregroundColor(CustomColor.sxcgreen))
                    .padding(10)
}

func passwordTextField(title: String, text: Binding <String>, width: CGFloat, height: CGFloat) -> some View {
    return SecureField(title, text: text)
        .frame(width: width, height: height)
        .padding(.vertical, 10)
                    .overlay(Rectangle().frame(height: 2).padding(.top, 35).foregroundColor(CustomColor.sxcgreen))
                    .padding(10)
}
