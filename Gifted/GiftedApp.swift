//
//  GiftedApp.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import Amplify
import SwiftUI
import AWSCognitoAuthPlugin
import AWSDataStorePlugin


@main
struct GiftedApp: App {
    
    @ObservedObject var sessionManager = SessionManager()
    
    init() {
        configureAmplify()
        sessionManager.getCurrentAuthUser()
    }
    
    var body: some Scene {
        WindowGroup {
            switch sessionManager.authState {
            case .login:
                LoginView()
                    .environmentObject(sessionManager)
                
            case .signUp:
                SignUpView()
                    .environmentObject(sessionManager)
                
            case .confirmCode(let username):
                ConfirmationView(username: username)
                    .environmentObject(sessionManager)
                
            case .session(let user):
                ContentView(user: user)
                    .environmentObject(sessionManager)
            }
        }
    }
    
    private func configureAmplify() {
        let dataStorePlugin = AWSDataStorePlugin(modelRegistration: AmplifyModels())
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.configure()
            print("Amplify configured successfully")
            
        } catch {
            print("could not initialize Amplify", error)
        }
    }
}

    


//struct GiftedApp: App {
//
//
//    init() {
//        configureAmplify()
//    }
//    var body: some Scene {
//        WindowGroup {
//            TabView {
//                NavigationView{
//                    FriendsView()
//                }
//                .tabItem{
//                    Image(systemName: "person.3.fill")
//                    Text("Friends")
//                }
//                NavigationView{
//                    ContentView()
//                }
//                .tabItem {
//                    Image(systemName: "house.circle.fill")
//                    Text("Home")
//                }
//                NavigationView{
//                    ItemDetailsView()
//                }
//                .tabItem{
//                    Image(systemName: "basket.fill")
//                    Text("Details")
//                }
//                NavigationView{
//                    LoginView()
//                }
//                .tabItem {
//                    Image(systemName: "lock.fill")
//                    Text("Login")
//                }
//            }
//        }
//    }
//    private func configureAmplify() {
//            do {
//                try Amplify.add(plugin: AWSCognitoAuthPlugin())
//                try Amplify.configure()
//                print("Amplify configured with auth plugin")
//            } catch {
//                print("Failed to initialize Amplify with \(error)")
//            }
//        }
//
//}
