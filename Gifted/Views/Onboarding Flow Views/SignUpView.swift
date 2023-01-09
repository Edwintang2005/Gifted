//
//  SignUpView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import SwiftUI

struct SignUpView: View {
    
    
    
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
        
        VStack(alignment: .leading) {
            TextField("Username", text: $username).pretty()
            TextField("Name (First and last)", text: $name).pretty()
                .keyboardType(.namePhonePad)
            TextField("Email", text: $email).pretty()
                .keyboardType(.emailAddress)
            Text("•  Valid Email Address")
                .verif()
                .foregroundColor(self.requirements[1] ? .green: .red)
                .padding(.horizontal)
            SecureField("Password", text: $password).pretty()
            VStack(alignment: .leading) {
                Text("Password Requirements:").homepagename()
                Text("•  Password longer than 8 characters")
                    .verif()
                    .foregroundColor(self.requirements[0] ? .green : .red)
                Text("•  Password contains capital letters")
                    .verif()
                    .foregroundColor(self.requirements[2] ? .green : .red)
                Text("•  Password contains lower-case letters")
                    .verif()
                    .foregroundColor(self.requirements[3] ? .green : .red)
                Text("•  Password contains a number")
                    .verif()
                    .foregroundColor(self.requirements[4] ? .green : .red)
            }
            .padding(.all)
            Button {
                print("Signed ip")
            } label: {
                Text("Sign up!")
                    .frame(maxWidth: .infinity)
            }
            .pretty()
            .padding(.top)
            Spacer()
            HStack {
                Spacer()
                Button {
                    print("show login")
                } label: {
                    Text("Already have an account? Log in.")
                        .frame(maxWidth: .infinity)
                }
                Spacer()
            }
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
