//
//  SignUpView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var username = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Text("Sign Up Here:")
                .font(.title3)
            Spacer()
            TextField("Username", text: $username).pretty()
            TextField("Email", text: $email).pretty()
            SecureField("Password (at least 8 characters)", text: $password).pretty()
            Button("Sign Up", action: {
                sessionManager.signUp(
                    username: username,
                    email: email,
                    password: password
                )
            }).pretty()
            Spacer()
            Button("Already have an account? Log in.", action: sessionManager.showLogin)
            Spacer()
            Text("Brought to you with ❤️ from Edwin Tang and Roger Yao")
                .font(.caption)
                .foregroundColor(Color.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
}


// Preview simulator code, ignore

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
