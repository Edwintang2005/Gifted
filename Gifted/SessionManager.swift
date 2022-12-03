//
//  SessionManager.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import Foundation
import Amplify



// object that detects if user is logged in or not
class AuthService: ObservableObject {
    @Published var isSignedIn = false
}

// Function for determining if user is signed in or not
func checkSessionStatus() {
    _ = Amplify.Auth.fetchAuthSession { [weak self] result in
        switch result {
        case .success(let session):
            DispatchQueue.main.async {
                self?.isSignedIn = session.isSignedIn
            }
            
        case .failure(let error):
            print(error)
        }
    }
}
