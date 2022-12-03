//
//  GiftedApp.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import Amplify
import SwiftUI
import AWSCognitoAuthPlugin
import AWSMobileClient





@main

//struct GiftedApp: App {
//    // initial property for detection of authentication process
//    @ObservedObject var auth = AuthService()
//
//
//    init() {
//        configureAmplify()
//        auth.checkSessionStatus()
//    }
//
//    var body: some Scene {
//        WindowGroup{
//            if auth.isSignedIn {
//                ContentView()
//                    .environmentObject(auth)
//            } else {
//                LoginView()
//                    .environmentObject(auth)
//            }
//        }
//
//        }
//    private func configureAmplify() {
//            do {
//                try Amplify.add(plugin: AWSCognitoAuthPlugin())
//                try Amplify.configure()
//                print("Amplify configured with auth plugin")
//            } catch {
//                print("Failed to initialize Amplify with \(error)")
//            }
//        }
//    }

    


struct GiftedApp: App {
    
    
    init() {
        configureAmplify()
    }
    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView{
                    FriendsView()
                }
                .tabItem{
                    Image(systemName: "person.3.fill")
                    Text("Friends")
                }
                NavigationView{
                    ContentView()
                }
                .tabItem {
                    Image(systemName: "house.circle.fill")
                    Text("Home")
                }
                NavigationView{
                    ItemDetailsView()
                }
                .tabItem{
                    Image(systemName: "basket.fill")
                    Text("Details")
                }
                NavigationView{
                    LoginView()
                }
                .tabItem {
                    Image(systemName: "lock.fill")
                    Text("Login")
                }
            }
        }
    }
    private func configureAmplify() {
            do {
                try Amplify.add(plugin: AWSCognitoAuthPlugin())
                try Amplify.configure()
                print("Amplify configured with auth plugin")
            } catch {
                print("Failed to initialize Amplify with \(error)")
            }
        }

}
