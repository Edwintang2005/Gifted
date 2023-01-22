//
//  AddToFriends.swift
//  Gifted
//
//  Created by Edwin Tang on 5/1/2023.
//

import SwiftUI

//Page trigged by add button in Friends
struct AddToFriends: View {
    
    @ObservedObject var dataStore = DataStore()
    @Environment(\.presentationMode) var presentationMode
    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    @State var username = String()
    @State var validUsername = true
    
    var body: some View{
        VStack {
            Spacer()
            TextField("Friend's Username", text: $username)
                .pretty()
            Text("Noone with that username exists")
                .verif()
                .foregroundColor(validUsername ? .clear: .red)
            Spacer()
            Button{
                saveFriend()
            } label: {
                Text("Save")
            }.pretty()
            Spacer()
        }
        .navigationTitle("Add a Friend!")
        .padding(.horizontal)
    }
        
    
    func saveFriend() {
        print(username)
        // Fetching ID of Friend and adding to friend list
        let friend = dataStore.verifUser(username: username)
        if friend.Username != "NULL" {
            dataStore.changeFriends(action: .addTo, userID: userID, change: friend)
            presentationMode.wrappedValue.dismiss()
        } else {
            validUsername = false
        }
    }
}

//struct AddToFriends_Previews: PreviewProvider {
//    static var previews: some View {
//        AddToFriends()
//    }
//}
