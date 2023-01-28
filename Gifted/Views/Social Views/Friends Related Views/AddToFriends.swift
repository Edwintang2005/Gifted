//
//  AddToFriends.swift
//  Gifted
//
//  Created by Edwin Tang on 5/1/2023.
//

import Amplify
import SwiftUI

//Page trigged by add button in Friends
struct AddToFriends: View{
    
    @ObservedObject var dataStore = DataStore()
    @Binding var displayPopup: popupState
    
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    let cardWidth = UIScreen.main.bounds.size.width * 9/10
    let cardHeight = UIScreen.main.bounds.size.height * 1/4
    let cornerRadius = 10.0
    
    @State var username = String()
    @State var validUsername = true
    
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
                Text("Add Friend")
                    .boldText()
                TextField("Friend's Username", text: $username)
                    .pretty()
                Text("This username doesn't exist")
                    .foregroundColor(validUsername ? .clear: .red)
                Button{
                    saveFriend()
                } label: {
                    Text("Add")
                }.pretty()
            }
            .padding(.bottom)
        }
        .background(Color(.sRGB, red: 237/255, green: 240/255, blue: 241/255))
        .padding(.all)
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
        
    
    func saveFriend() {
        print(username)
        // Fetching ID of Friend and adding to friend list
        let friend = dataStore.verifUser(username: username)
        if friend.Username != "NULL" {
            dataStore.changeFriends(action: .addTo, userID: userID, change: friend)
            displayPopup = .None
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
