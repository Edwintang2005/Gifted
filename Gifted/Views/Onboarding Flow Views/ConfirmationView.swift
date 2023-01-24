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
        VStack(alignment: .center) {
            Spacer()
            Text("Verify your identity")
                .colourGradient()
                .font(.largeTitle)
            Text("Enter the 6-digit code sent to your email")
                .boldText()
            Image("VerificationStock")
                .resizable()
                .aspectRatio(contentMode: .fit)
            TextField("Confirmation Code", text: $confirmationCode)
                .pretty()
                .keyboardType(.numberPad)
            Text("Check your email for a code").medium()
            Button {
                sessionManager.confirm(
                    username: username,
                    code: confirmationCode
                )
            } label: {
                Text("Confirm")
                    .frame(maxWidth: .infinity)
            }.pretty()
            Spacer()
            Text("Brought to you with ❤️ from Edwin, Roger and Michelle").small()
        }
        .padding()
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(username: "Test User")
    }
}

