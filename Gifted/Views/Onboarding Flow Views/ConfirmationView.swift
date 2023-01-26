//
//  ConfirmationView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import SwiftUI

struct ConfirmationView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var confirmationCode = ""
    
    let username: String
    
    var body: some View {
        Spacer()
        VStack(alignment: .center) {
            VStack {
                Text("Verify your identity")
                    .title()
                Text("Enter the 6-digit code sent to your email")
                    .boldText()
            }
            .padding(.vertical)
            TextField("Confirmation Code", text: $confirmationCode)
                .pretty()
                .keyboardType(.numberPad)
            HStack {
                Button {
                    sessionManager.resendcode(username: username)
                } label: {
                    Text("Resend code")
                        .frame(maxWidth: .infinity)
                }
                .secondary()
                Button {
                    sessionManager.confirm(
                        username: username,
                        code: confirmationCode
                    )
                } label: {
                    Text("Confirm")
                        .frame(maxWidth: .infinity)
                }.pretty()
            }
        }
        .loadingFrame()
        .padding(.all)
        Spacer()
        signoff()
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "Test User")
    }
}

