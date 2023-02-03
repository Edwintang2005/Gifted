//
//  GiftedApp.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import Amplify // Base Amplify Plugin
import SwiftUI // Base Visual Module
import AWSCognitoAuthPlugin // Base Authentication Model
import AWSDataStorePlugin // Base Interaction with DataStore Model
import AWSAPIPlugin // Base Plugin for all AWS Plugin activity
import AWSS3StoragePlugin // Base Plugin for interaction with Storage (Basically transfer of images etc.)



@main
struct GiftedApp: App {
    
    @ObservedObject var sessionManager = SessionManager()
    @ObservedObject var menuViewController = MenuViewController()
    
    // All Amplify and AWS Functionality require this configuration before anything can work, getCurrentAuthUser verifies if user is signed in
    init() {
        configureAmplify()
        sessionManager.getCurrentAuthUser()
        Amplify.DataStore.start(){
            switch $0{
            case .success:
                print("Began DataStore Sync")
            case .failure(let error):
                print("Could not begin DataStore Sync - \(error.localizedDescription)")
            }
        }
    }
    
    // Main logic/ UI controlboard
    var body: some Scene {
        WindowGroup {
            
            // Breaking down the data recieved from the User Signin state manager
            switch sessionManager.authState {
                
            // Displays the login screen if user isn't logged in
            case .login:
                LoginView()
                    .environmentObject(sessionManager)
                
            // Displays the Signup screen to allow for account signup
            case .signUp:
                SignUpView()
                    .environmentObject(sessionManager)
                
            // Displays the temporary unavailable screen for any features before signup not yet implemented
            case .unavailable:
                TempUnavailable()
                    .environmentObject(sessionManager)
                
            // Displays a screen that takes a confirmation code for verification after signup
            case .confirmCode(let username):
                ConfirmationView(username: username)
                    .environmentObject(sessionManager)
                
            // Displays the homescreen for logged in users
            case .session(let user):
                ContentView(user: user)
                    .environmentObject(sessionManager)
                    .environmentObject(menuViewController)
            }
        }
    }
    
    
    // The function that actually ensures all AWS services work, called above
    private func configureAmplify() {
        do {
            //Storage
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: AWSS3StoragePlugin())
            
            //Datastore
            let models = AmplifyModels()
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: models))
            
            // Configure Plugins
            try Amplify.configure()
            print("Amplify configured successfully")
            
        } catch {
            print("could not initialize Amplify", error)
        }
    }
}

