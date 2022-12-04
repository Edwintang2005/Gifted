//
//  LoginView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
        
    @State var username = ""
    @State var password = ""
    
    
    var body: some View {
        VStack {
            // can be app icon - Edwin
            VStack {
                        Spacer()
                        TextField("Username", text: $username).pretty()
                        SecureField("Password", text: $password).pretty()
                        Button("Login", action: {
                            sessionManager.login(
                                username: username,
                                password: password
                            )
                            print("logged in")
                            
                        }).pretty()
                        
                        Spacer()
                        Button("Don't have an account? Sign up.", action: sessionManager.showSignUp)
                    }
                    .padding()
            
            
            // vertical stack created for easier button placement
            VStack(spacing: 10) {
                // Button for email signin
                Button{
                    print("Email Button clicked") // Dud function, replace later
                } label: {
                    Image(systemName: "envelope.fill")
                        .imageScale(.medium)
                    Text("Continue with Email")
                }
                .font(.body.weight(.medium))
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .clipped()
                .foregroundColor(Color(.displayP3, red: 244/255, green: 188/255, blue: 73/255))
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.clear.opacity(0.25), lineWidth: 0)
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.yellow.opacity(0.1)))
                }
                // Button for Gmail Signin
                Button{ action:do {
                    print("Gmail Button clicked") // Dud function, replace later
                }
                } label: {
                    Image(systemName: "envelope.fill")
                        .imageScale(.medium)
                    Text("Continue with Gmail")
                }
                .font(.body.weight(.medium))
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(.systemBackground))
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.clear.opacity(0.25), lineWidth: 0)
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(.displayP3, red: 219/255, green: 68/255, blue: 55/255)))
                }
                // Function for Apple signin
                Button {
                    print("tested") // Dud function, replace later
                } label: {
                    Image(systemName: "f.cursive")
                        .imageScale(.medium)
                    Text("Continue with Facebook")
                }
                .font(.body.weight(.medium))
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .clipped()
                .foregroundColor(Color(.systemBackground))
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(.displayP3, red: 23/255, green: 120/255, blue: 242/255))
                }
                Text("Sign Up")
                    .fontWeight(.bold)
                    .padding(.top)
                    .foregroundColor(Color(.secondaryLabel))
                    .font(.body)
            }
            .padding(.horizontal)
            Spacer()
        }
        .frame(width: 390, height: 844)
        .clipped()
        .background(Color(.systemBackground))
        .mask { RoundedRectangle(cornerRadius: 43, style: .continuous) }
    }
}


// Ignore below, simulator code
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
