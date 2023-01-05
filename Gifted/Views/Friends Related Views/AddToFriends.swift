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
    
    @Environment(\.presentationMode) var presentationMode
    
    let selfUsername = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    
    @State var username = String()
    
    
    var body: some View{
        VStack {
            Spacer()
            TextField("Friend's Username", text: $username).pretty()
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
        
        let UserObj = UserProfile.keys
        print(username)
        
        // Fetching ID of Friend and adding to friend list
        Amplify.DataStore.query(UserProfile.self, where: UserObj.Username == username) { result in
            switch result {
            case.success(let Friends):
                if let Friend = Friends.first {
                    // Fetching own User Item
                    Amplify.DataStore.query(UserProfile.self, where: UserObj.Username == selfUsername) { result in
                        switch result {
                        case .success( let user):
                            if var userSelf = user.first {
                                var friends = userSelf.Friends
                                friends.append(Friend.id)
                                userSelf.Friends = friends
                                Amplify.DataStore.save(userSelf) {result in
                                    switch result {
                                    case .success:
                                        print("Successfully added Friend")
                                        presentationMode.wrappedValue.dismiss()
                                    case .failure(let error):
                                        print("Could not add Friend - \(error)")
                                    }
                                }
                            }
                        case .failure(let error):
                            print("Could not fetch Self - \(error)")
                        }
                    }
                }
            case.failure(let error):
                print("Could not fetch Friend - \(error)")
            }
        }
    }
}

//struct AddToFriends_Previews: PreviewProvider {
//    static var previews: some View {
//        AddToFriends()
//    }
//}
