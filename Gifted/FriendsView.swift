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
    
    @State var showAddToFriends = false
    @State var Friends = [Friend]()
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
                                ListView(QueryUsername: Friend.Username ?? "NullUser")
                            } label: {
                                Text(Friend.Username ?? " ")
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
        let username = UserDefaults.standard.string(forKey: "Username") ?? "nullUser"
        let FriendObj = Friend.keys
        Amplify.DataStore.query(Friend.self, where: FriendObj.OwnerUser == username) {result in
            switch result {
            case .success(let FriendList):
                print(FriendList)
                self.Friends = FriendList
            case .failure(let error):
                print(error)
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
        
        Amplify.DataStore.delete(item) { result in
            switch result {
            case .success:
                print("Deleted Friend")
            case .failure(let error):
                print("Could not delete Friend - \(error)")
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
