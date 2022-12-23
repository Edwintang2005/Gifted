//
//  SessionManager.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import Foundation
import Amplify
import AWSPluginsCore


// Global variable that controls the state that the user is in regarding signin. This saves even after app close
enum AuthState {
    case unavailable
    case signUp
    case login
    case confirmCode(username: String)
    case session(user: AuthUser)
}

// User Signin state manager
final class SessionManager: ObservableObject {
    
    @Published var authState: AuthState = .login
    
    
    func getCurrentAuthUser() {
        if let user = Amplify.Auth.getCurrentUser() {
            authState = .session(user: user)
        } else {
            authState = .login
        }
    }
    
    // Controller function to show signup page
    func showSignUp() {
        authState = .signUp
    }
    
    // Controller function to show login page
    func showLogin() {
        authState = .login
    }
    
    // Controller function to show temporary unavailable page
    func showUnavailable() {
        authState = .unavailable
    }
    
    // Controller function to show signup page
    func signUp(username: String, email: String, name: String, password: String) {
        
        let user = User(
            id: UUID().uuidString,
            Username: username,
            Items: [String](),
            Friends: [String](),
            Groups: [String]()
        )
        
        let attributes = [
            AuthUserAttribute(.email, value: email),
            AuthUserAttribute(.name, value: name)
        ]
        let options = AuthSignUpRequest.Options(userAttributes: attributes)
        
        _ = Amplify.Auth.signUp(
            username: username,
            password: password,
            options: options
        ) { [weak self] result in
            
            switch result {
            
            case .success(let signUpResult):
                print("Sign up result:", signUpResult)
                Amplify.DataStore.save(user) { result in
                    switch result {
                    case .success:
                        print("User Record Created!")
                    case .failure(let error):
                        print("Could not create user - \(error)")
                    }
                }
                switch signUpResult.nextStep {
                case .done:
                    print("Finished sign up")
                    
                case .confirmUser(let details, _):
                    print(details ?? "no details")
                    
                    DispatchQueue.main.async {
                        self?.authState = .confirmCode(username: username)
                    }
                }
                
            case .failure(let error):
                print("Sing up error", error)
            }
            
        }
    }
    
    // Function to make the confirmation code authentication work
    func confirm(username: String, code: String) {
        _ = Amplify.Auth.confirmSignUp(
            for: username,
            confirmationCode: code
        ) { [weak self] result in
            
            switch result {
            case .success(let confirmResult):
                print(confirmResult)
                if confirmResult.isSignupComplete {
                    DispatchQueue.main.async {
                        self?.showLogin()
                    }
                }
                
            case .failure(let error):
                print("failed to confirm code:", error)
            }
        }
    }
    
    // Function to allow users to login
    func login(username: String, password: String) {
        _ = Amplify.Auth.signIn(
            username: username,
            password: password
        ) { [weak self] result in
            
            switch result {
            case .success(let signInResult):
                print(signInResult)
                if signInResult.isSignedIn {
                    DispatchQueue.main.async {
                        self?.getCurrentAuthUser()
                    }
                }
            case .failure(let error):
                print("Login error:", error)
            }
        }
    }
    
    // Function that allows users to signout and clears any cache data on user device
    func signOut() {
        _ = Amplify.Auth.signOut { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.getCurrentAuthUser()
                }
                Amplify.DataStore.clear()
                
            case .failure(let error):
                print("Sign out error:", error)
            }
        }
    }
}
