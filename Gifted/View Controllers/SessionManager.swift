//
//  SessionManager.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import Amplify
import AWSPluginsCore
import Foundation
import SwiftUI

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
    
    // To login after confirmation of signup
    @AppStorage("LoginUsername") var loginuser: String = ""
    @AppStorage("LoginPassword") var loginpass: String = ""
    
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
                switch signUpResult.nextStep {
                case .done:
                    print("Finished sign up")
                    
                case .confirmUser(let details, _):
                    print(details ?? "no details")
                    
                    DispatchQueue.main.async {
                        self?.loginuser = username
                        self?.loginpass = password
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
                        if let usernme = self?.loginuser, let pass = self?.loginpass {
                            self?.login(username: usernme, password: pass)
                        } else {
                            self?.showLogin()
                        }
                    }
                }
                
            case .failure(let error):
                print("failed to confirm code:", error)
            }
        }
    }
    
    func resendcode(username: String) {
        Amplify.Auth.resendSignUpCode(for: username) {
            switch $0 {
            case .success(let deliveryDetails):
                print("Successfully resent code - \(deliveryDetails)")
            case .failure(let error):
                print("Could not resend code - \(error.localizedDescription)")
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
                        self?.loginuser = ""
                        self?.loginpass = ""
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
                    self?.backendStopandReset()
                }
            case .failure(let error):
                print("Sign out error:", error)
            }
        }
    }
    
    func deleteUser() {
        Amplify.Auth.deleteUser() {
            switch $0 {
            case .success():
                print("Account Deleted")
            case .failure(let error):
                print("Could not delete account - \(error.localizedDescription)")
            }
        }
    }
    
    func backendStopandReset() {
        Amplify.DataStore.clear { result in
            switch result {
            case .success:
                print("DataStore cleared")
            case .failure(let error):
                print("Error clearing DataStore: \(error)")
            }
        }
    }
}
