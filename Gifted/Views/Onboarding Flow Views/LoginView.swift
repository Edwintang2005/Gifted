//
//  LoginView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    // Variables for the input fields to satisfy login functionality
    @State var username = ""
    @State var password = ""
    
    var body: some View {
        Spacer()
        VStack {
            // Username signin functionality
            VStack {
                VStack(alignment: .center){
                    Text("Welcome back!").title()
                    Text("Enter your details").boldText()
                }
                TextField("Username", text: $username).pretty()
                SecureField("Password", text: $password).pretty()
                Button {
                    sessionManager.login(
                        username: username,
                        password: password
                    )
                    print("logged in")
                } label: {
                    Text("Login")
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                }.pretty()
            }
            .padding(.all)
            
            
            // The Big line with an or in the middle, for appearances
            // LabelledDivider(label: "OR")
            
            
            // vertical stack created for easier button placement
            VStack {
//                HStack{
//                    // Button for Gmail Signin
//                    Button{ action:do {
//                        sessionManager.showUnavailable() // Dud function, replace with actual functionality later
//                    }
//                    } label: {
//                        HStack{
//                            Image(systemName: "envelope.fill")
//                                .imageScale(.medium)
//                            Text(" Gmail")
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding(.horizontal)
//                    }.google()
//                    // Button for Facebook signin
//                    Button {
//                        sessionManager.showUnavailable() // Dud function, replace with actual functionality later
//                    } label: {
//                        HStack{
//                            Image(systemName: "f.cursive")
//                                .imageScale(.medium)
//                            Text(" Facebook")
//                        }
//                        .frame(maxWidth: .infinity)
//                        .padding(.horizontal)
//                    }.facebook()
//                }
                Text("Don't have an account?")
                Button("Sign up", action: sessionManager.showSignUp)
                    .tint(Color(.sRGB, red: 37/255, green: 75/255, blue: 72/255))
            }
            .padding(.all)
        }
        .loadingFrame()
        Spacer()
        signoff()
    }
}

// Display view (temporary) for unavailable views
struct TempUnavailable: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    var body: some View{
        VStack{
            Spacer()
            Text("Unfortunately This feature isn't yet Available 😩 \n \n Perhaps in the next Update??").pretty()
            Spacer()
            Text("Or you could just donate to us devs to speed things along, button below!")
            Spacer()
            Link("Donate Here!", destination: URL(string:"https://www.youtube.com/watch?v=dQw4w9WgXcQ")!).pretty()
            Button{
                sessionManager.showLogin()
            } label: {
                Text("Back to Login")
            }
            Spacer()
        }
    }
}

// Ignore below, simulator code


//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}



