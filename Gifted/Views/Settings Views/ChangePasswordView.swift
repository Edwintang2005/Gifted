//
//  ChangePasswordView.swift
//  Gifted
//
//  Created by Edwin Tang on 30/1/2023.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @ObservedObject var dataStore = DataStore()
    @EnvironmentObject var sessionManager: SessionManager
    
    @Binding var displayPopup: settingsPopup
    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    let cardWidth = UIScreen.main.bounds.size.width * 9/10
    let cardHeight = UIScreen.main.bounds.size.height * 3/8
    let cornerRadius = 10.0
    
    @State var oldPassword = String()
    @State var newPassword = String()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    displayPopup = .None
                } label: {
                    Image(systemName: "x.circle")
                        .imageScale(.large)
                }
            }
            .padding(.top)
            VStack {
                Text("Set a new password")
                    .boldText()
                TextField("Old Password", text: $oldPassword)
                    .pretty()
                TextField("New Password", text: $newPassword)
                    .pretty()
                Button{
                    savePassword()
                    displayPopup = .None
                } label: {
                    Text("Save")
                }.pretty()
            }
            .padding(.bottom)
        }
        .background(Color(.sRGB, red: 237/255, green: 240/255, blue: 241/255))
        .padding(.all)
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
    
    
    func savePassword() {
        sessionManager.changePassword(oldPassword: oldPassword, newPassword: newPassword)
    }
}


//struct ChangePasswordView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangePasswordView()
//    }
//}
