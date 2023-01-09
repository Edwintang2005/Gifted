//
//  GiftedApp.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import SwiftUI // Base Visual Module


@main
struct GiftedApp: App {
    
    @ObservedObject var menuViewController = MenuViewController()
    
    // All Amplify and AWS Functionality require this configuration before anything can work, getCurrentAuthUser verifies if user is signed in
    init() {
    }
    
    // Main logic/ UI controlboard
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(menuViewController)
            // Breaking down the data recieved from the User Signin state manager
        }
    }
    
    
    
    
}

