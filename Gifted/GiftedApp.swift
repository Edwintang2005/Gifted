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
import AWSAPIPlugin
import AWSS3StoragePlugin


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
            case .unavailable:
                TempUnavailable()
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
        let apiPlugin = AWSAPIPlugin(modelRegistration: AmplifyModels())
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.add(plugin: dataStorePlugin)
            try Amplify.add(plugin: apiPlugin)
            try Amplify.configure()
            print("Amplify configured successfully")
            
        } catch {
            print("could not initialize Amplify", error)
        }
    }
}

