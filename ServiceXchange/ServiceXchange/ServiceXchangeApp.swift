//
//  ServiceXchangeApp.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/24/23.
//

import SwiftUI

@main
struct ServiceXchangeApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var session = SessionStore()


  var body: some Scene {
    WindowGroup {
      NavigationView {
        CalendarView(forUser: "7syxwXFCwYh6HevOXCD9oTJJV7n1")//ContentView() // Right Click -> "Jump to Definition" to go through viewcontroller flow.
            .environmentObject(session)
            .preferredColorScheme(.light)
      }
    }
  }
}

struct CustomColor {
    static let sxcgreen = Color("sxcgreen")
}





