//
//  SignUpView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    
    // Variables taken for each input field available
    @State var username = ""
    @State var email = ""
    @State var password = ""
    
    private var requirements: Array<Bool> {
        [
            password.count >= 8,  // Verifying Minimum Length
            isValidEmailAddress(emailAddressString: email)
        ]
    }
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Username", text: $username).pretty()
            TextField("Email", text: $email).pretty()
            SecureField("Password", text: $password).pretty()
            HStack {
                VStack(alignment: .leading) {
                    Text("Signup Conditions:").homepagename()
                    Text("•  Valid Email Address")
                        .verif()
                        .foregroundColor(self.requirements[1] ? .green: .red)
                    Text("•  Password longer than 8 characters")
                        .verif()
                        .foregroundColor(self.requirements[0] ? .green : .red)
                }
                Spacer()
            }
            
            Button {
                sessionManager.signUp(
                    username: username,
                    email: email,
                    password: password
                )
            } label: {
                Text("Sign up!")
                    .frame(maxWidth: .infinity)
            }.pretty()
            Spacer()
            Button("Already have an account? Log in.", action: sessionManager.showLogin)
            Spacer()
            Text("Brought to you with ❤️ from Edwin Tang and Roger Yao").small()
        }
        .padding()
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
      
      var returnValue = true
      let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
      
      do {
          let regex = try NSRegularExpression(pattern: emailRegEx)
          let nsString = emailAddressString as NSString
          let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
          
          if results.count == 0
          {
              returnValue = false
          }
          
      } catch let error as NSError {
          print("invalid regex: \(error.localizedDescription)")
          returnValue = false
      }
      
      return  returnValue
  }
}


// Preview simulator code, ignore

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
