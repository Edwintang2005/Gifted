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
    @State var name = ""
    @State var password = ""
    
    private var requirements: Array<Bool> {
        [
            password.count >= 8,  // Verifying Minimum Length
            isValidEmailAddress(emailAddressString: email), // Verifying email address
            capitalLetterTest(password: password), // verifying capital letter
            lowerLetterTest(password: password), // verifying lower letter
            numberTest(password: password) // verifying number
        ]
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                Text("Get Started!")
                    .title()
                    .padding(.top)
                Text("Enter your details").boldText()
                VStack{
                    TextField("Username", text: $username).pretty()
                    TextField("Name (First and last)", text: $name).pretty()
                        .keyboardType(.namePhonePad)
                    TextField("Email", text: $email).pretty()
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $password).pretty()
                    Button {
                        sessionManager.signUp(
                            username: username,
                            email: email,
                            name: name,
                            password: password
                        )
                    } label: {
                        Text("Sign up")
                            .frame(maxWidth: .infinity)
                    }
                    .pretty()
                    .padding(.top)
                }
            }
            VStack(alignment: .leading) {
                Text("Signup Requirements:").homepagename()
                Text("•  Valid Email Address")
                    .verif()
                    .foregroundColor(self.requirements[1] ? .clear: .red)
                Text("•  Password longer than 8 characters")
                    .verif()
                    .foregroundColor(self.requirements[0] ? .clear : .red)
                Text("•  Password contains capital letters")
                    .verif()
                    .foregroundColor(self.requirements[2] ? .clear : .red)
                Text("•  Password contains lower-case letters")
                    .verif()
                    .foregroundColor(self.requirements[3] ? .clear : .red)
                Text("•  Password contains a number")
                    .verif()
                    .foregroundColor(self.requirements[4] ? .clear : .red)
                Spacer()
                HStack{
                    Spacer()
                    VStack (alignment: .center) {
                        Text("Already have an account?")
                        Button("Log in", action: sessionManager.showLogin)
                            .tint(Color(.sRGB, red: 37/255, green: 75/255, blue: 72/255))
                    }
                    Spacer()
                }
            }
            .padding(.all)
        }
        .loadingFrame()
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color(.displayP3, red: 239/255, green: 245/255, blue: 227/255))
        }
        Spacer()
        signoff()
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    func capitalLetterTest(password: String) -> Bool {
        var returnValue = true
        let capitalRegEx = ".*[A-Z]+.*"
        do {
            let regex = try NSRegularExpression(pattern: capitalRegEx)
            let nsString = password as NSString
            let results = regex.matches(in: password, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
        } catch let error as NSError {
            print("Invalid Regex: \(error.localizedDescription)")
            returnValue = false
        }
        return returnValue
    }
    
    func lowerLetterTest(password: String) -> Bool {
        var returnValue = true
        let lowerRegEx = ".*[a-z]+.*"
        do {
            let regex = try NSRegularExpression(pattern: lowerRegEx)
            let nsString = password as NSString
            let results = regex.matches(in: password, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
        } catch let error as NSError {
            print("Invalid Regex: \(error.localizedDescription)")
            returnValue = false
        }
        return returnValue
    }
    
    func numberTest(password: String) -> Bool {
        var returnValue = true
        let numberRegEx = ".*[0-9]+.*"
        do {
            let regex = try NSRegularExpression(pattern: numberRegEx)
            let nsString = password as NSString
            let results = regex.matches(in: password, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
        } catch let error as NSError {
            print("Invalid Regex: \(error.localizedDescription)")
            returnValue = false
        }
        return returnValue
    }
}


// Preview simulator code, ignore

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
