//
//  CarerilepsyApp.swift
//  Carerilepsy
//
//  Created by Cameron Crawford on 10/07/2021.
//

import SwiftUI
import Firebase

@main
struct CarerilepsyApp: App {
    // Attaching App Delegate to SwiftUI
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Creating App Delegate
class AppDelegate: NSObject,UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Initializing Firebase
        FirebaseApp.configure()
        return true
    }
    
}


