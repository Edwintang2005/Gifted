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
    @Binding var displayPopup: popupState
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("CONTACTS").boldText()
                        .padding(.horizontal)
                    Spacer()
                    Button {
                        displayPopup = popupState.addFriend
                    } label: {
                        Image(systemName:"person.badge.plus")
                            .imageScale(.large)
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
            .disabled(displayPopup == .addFriend)
            
            if displayPopup == .addFriend {
                AddToFriends(displayPopup: $displayPopup)
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
