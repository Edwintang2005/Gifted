//
//  FriendsView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//


import Combine
import SwiftUI

// Page for friends lists, not yet built although buttons and structures are all done, just need backend functionality
struct FriendsView: View {
    
    @ObservedObject var dataStore = DataStore()
    
    
    let username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    @State var Friends = [UserProfile]()
    @State var FriendsLength = Int()
    
    
    var body: some View {
        ZStack {
            VStack {
                if FriendsLength == 1 {
                    Spacer()
                    Text("You have no friends yet! 😢").large()
                    Spacer()
                    Text("Why don't we start by adding an item using the + button!").large()
                    Spacer()
                } else {
                    List {
                        ForEach(Friends) {
                            Friend in NavigationLink{
                                ListView(QueryID: Friend.id)
                            } label: {
                                Text(Friend.Username)
                            }
                        }
                        .onDelete(perform: deleteFriend)
                    }
                }
            }
            VStack{
                    NavigationLink{
                        AddToFriends()
                    } label: {
                        Text("Add Friend").buttonDesign()
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            getFriends()
            FriendsLength = Friends.count
        }
    }
    
    func getFriends() {
        Friends = dataStore.fetchFriends(userID: userID)
    }
    
    func deleteFriend(indexSet: IndexSet) {
        print("Deleted friend at \(indexSet)")
        
        var updatedList = Friends
        updatedList.remove(atOffsets: indexSet)

        guard let item =
                Set(updatedList)
            .symmetricDifference(Friends).first else
        {return}
        
        // Function to remove friend from list
        dataStore.changeFriends(action: .removeFrom, userID: userID, change: item)
        getFriends()
    }
}






//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsView()
//    }
//}
