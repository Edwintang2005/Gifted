//
//  LoginView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    @AppStorage("Username") var Username: String = ""
    @AppStorage("Password") var Password: String = ""
    @State var username = ""
    @State var password = ""
    @State var name = ""
    
    
    var body: some View {
        VStack {
            // Email signin functionality
            VStack {
                Spacer()
                Text("Welcome to Gifted!")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                Spacer()
                Text("Login Here:")
                    .font(.title3)
                Spacer()
                TextField("Username", text: $username).pretty()
                SecureField("Password", text: $password).pretty()
                Button("Login", action: {
                    sessionManager.login(
                        username: username,
                        password: password
                    )
                    print("logged in")
                    Username = username
                    Password = password
                }).pretty()
            }
            .padding(.horizontal)
            LabelledDivider(label: "OR")
            // vertical stack created for easier button placement
            VStack(spacing: 8) {
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
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(.systemBackground))
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(.clear.opacity(0.25), lineWidth: 0)
                    .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(.displayP3, red: 219/255, green: 68/255, blue: 55/255)))
                }
                // Function for Facebook signin
                Button {
                    print("Facebook Button clicked") // Dud function, replace later
                } label: {
                    Image(systemName: "f.cursive")
                        .imageScale(.medium)
                    Text("Continue with Facebook")
                }
                .font(.body.weight(.medium))
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .clipped()
                .foregroundColor(Color(.systemBackground))
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(.displayP3, red: 23/255, green: 120/255, blue: 242/255))
                }
                Spacer()
                Button("Don't have an account? Sign up.", action: sessionManager.showSignUp)
                Spacer()
                Text("Brought to you with ❤️ from Edwin Tang and Roger Yao")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .background(Color(.systemBackground))
        .mask { RoundedRectangle(cornerRadius: 43, style: .continuous) }
    }
}





// Code for Labelled Divider
struct LabelledDivider: View {

    let label: String
    let horizontalPadding: CGFloat
    let color: Color

    init(label: String, horizontalPadding: CGFloat = 20, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack {
            line
            Text(label).foregroundColor(color)
            line
        }
    }

    var line: some View {
        VStack { Divider().background(color) }.padding(horizontalPadding)
    }
}


// Ignore below, simulator code


//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}



