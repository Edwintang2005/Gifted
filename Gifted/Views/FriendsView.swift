//
//  FriendsView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//


import Amplify
import Combine
import SwiftUI

// Page for friends lists, not yet built although buttons and structures are all done, just need backend functionality
struct FriendsView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    let username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    @State var showAddToFriends = false
    @State var Friends = [User]()
    @State var FriendsLength = Int()
    
    
    var body: some View {
        ZStack {
            VStack {
                if FriendsLength == 0 {
                    Spacer()
                    Text("You have No Friends yet! 😢").large()
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
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink{
                        AddToFriends()
                    } label: {
                        Image(systemName: "plus.circle.fill").floaty()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            getFriends()
            FriendsLength = Friends.count
        }
        .navigationBarTitle("Friends")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: (
            Button(action: {
                getFriends()
                FriendsLength = Friends.count
            }) {
                Image(systemName: "arrow.clockwise")
                    .imageScale(.large)
            }
        ))
    }
    
    func getFriends() {
        
        var FriendList = [User]()
        
        Amplify.DataStore.query(User.self, byId: userID) {result in
            switch result {
            case .success(let user):
                if let singleUser = user {
                    print(singleUser.Friends)
                    singleUser.Friends.forEach{friend in
                        Amplify.DataStore.query(User.self, byId: friend) { result in
                            switch result {
                            case .success(let Friend):
                                if let appendingFriend = Friend {
                                    FriendList.append(appendingFriend)
                                }
                            case .failure(let error):
                                print("Could not fetch friend - \(error)")
                            }
                        }
                    }
                    self.Friends = FriendList
                }
            case .failure(let error):
                print("Could not fetch User - \(error)")
            }
        }
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
        Amplify.DataStore.query(User.self, byId: userID) { result in
            switch result {
            case.success(let user):
                if var singleUser = user {
                    var friends = singleUser.Friends
                    friends = friends.filter { $0 != item.id }
                    singleUser.Friends = friends
                    Amplify.DataStore.save (singleUser) {result in
                        switch result {
                        case .success:
                            print("Successfully deleted Friend")
                        case .failure(let error):
                            print("Could not delete Friend - \(error)")
                        }
                    }
                }
            case.failure(let error):
                print("Could not fetch User - \(error)")
            }
        }
        getFriends()
    }
}






//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsView()
//    }
//}
