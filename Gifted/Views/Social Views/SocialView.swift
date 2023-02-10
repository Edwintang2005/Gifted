//
//  SocialView.swift
//  Gifted
//
//  Created by Edwin Tang on 6/1/2023.
//

import SwiftUI

enum tabPage {
    case Friends
    case Groups
}

enum popupState {
    case None
    case addFriend
    case friendInfo
    case friendWishlist
    case joinGroup
    case createGroup
}

struct SocialView: View {
    
    @Binding var ImageCache: [String: UIImage]
    
    @State private var selectedTab: tabPage = .Friends
    @State private var selection = tabPage.Friends
    @State var displayPopup = popupState.None
    
    @State var displayedProfile = UserProfile(Username: String(), Name: String())
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    VStack(alignment: .leading) {
                        Text("Social")
                            .colourGradient()
                            .padding(.horizontal)
                        Picker("", selection: $selection) {
                            Text("Friends")
                                .tag(tabPage.Friends)
                            Text("Groups")
                                .tag(tabPage.Groups)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                    }
                    if selection == .Friends {
                        FriendsView(ImageCache: $ImageCache, displayPopup: $displayPopup, displayedProfile: $displayedProfile)
                    } else {
                        GroupsView(ImageCache: $ImageCache, displayPopup: $displayPopup)
                    }
                }
                if displayPopup != .None {
                    Rectangle()
                        .fill(.black)
                        .opacity(0.5)
                        .ignoresSafeArea(.all, edges: .top)
                        .onTapGesture{
                            displayPopup = .None
                        }
                }
                if displayPopup == .addFriend {
                    AddToFriends(displayPopup: $displayPopup)
                } else if displayPopup == .friendInfo {
                    VStack {
                        Spacer()
                        FriendsDetailsView(displayPopup: $displayPopup, ImageCache: $ImageCache, friend: $displayedProfile)
                    }
                } else if displayPopup == .friendWishlist {
                    FriendListView(displayPopup: $displayPopup, friend: $displayedProfile, ImageCache: $ImageCache)
                } else if displayPopup == .joinGroup {
                    AddToGroups(displayPopup: $displayPopup)
                } else if displayPopup == .createGroup {
                    CreateNewGroup(displayPopup: $displayPopup)
                }
            }
            
        }
    }
}

//struct SocialView_Previews: PreviewProvider {
//    static var previews: some View {
//        SocialView()
//    }
//}
