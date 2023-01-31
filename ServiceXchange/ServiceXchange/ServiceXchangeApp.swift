//
//  ServiceXchangeApp.swift
//  ServiceXchange
//
//  Created by Dillon Kermani on 1/24/23.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ServiceXchangeApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var session = SessionStore()


  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
            .environmentObject(session)
      }
    }
  }
}

struct CustomColor {
    static let sxcgreen = Color("sxcgreen")
}
