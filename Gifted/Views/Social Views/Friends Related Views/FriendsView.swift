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
    @Binding var displayPopup: popupState
    
    let username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    @State var Friends = [UserProfile]()
    @State var FriendsLength = Int()
    @State var displayedProfile = UserProfile(Username: String(), Name: String())
    
    
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
                    ScrollView {
                        ForEach(Friends) {
                            Friend in Button{
                                displayedProfile = Friend
                                displayPopup = .friendInfo
                            } label: {
                                FriendDisplayCards(friend: Friend, ImageCache: $ImageCache)
                            }
                        }
                    }
                }
            }
            .disabled(displayPopup != .None)
            .opacity(displayPopup == .None ? 1: 0.5)
            if displayPopup == .addFriend {
                AddToFriends(displayPopup: $displayPopup)
            } else if displayPopup == .friendInfo {
                VStack {
                    Spacer()
                    FriendsDetailsView(displayPopup: $displayPopup, ImageCache: $ImageCache, friend: $displayedProfile)
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
}






//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsView()
//    }
//}
