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
    
    @ObservedObject var dataStore = DataStore()
    @EnvironmentObject var sessionManager: SessionManager
    
    @Binding var ImageCache: [String: UIImage]
    
    let username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    @State var Friends = [UserProfile]()
    @State var FriendsLength = Int()
    
    
    var body: some View {
        VStack {
            HStack {
                Text("CONTACTS").boldText()
                    .padding(.horizontal)
                Spacer()
                NavigationLink {
                    AddToFriends()
                } label: {
                    Image(systemName:"person.badge.plus")
                        .scaledToFit()
                        .foregroundColor(Color(.sRGB, red: 36/255, green: 74/255, blue: 71/255))
                    
                }
            }
            .padding(.all)
            
            if FriendsLength == 0 {
                Spacer()
                Text("Hopefully it's not normally like this... \n Add some friends!")
                    .multilineTextAlignment(.center)
                Spacer()
            } else {
                List {
                    ForEach(Friends) {
                        Friend in NavigationLink{
                            ListView(QueryID: Friend.id)
                        } label: {
                            FriendDisplayCards(friend: Friend, ImageCache: $ImageCache)
                        }
                    }
                    .onDelete(perform: deleteFriend)
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
