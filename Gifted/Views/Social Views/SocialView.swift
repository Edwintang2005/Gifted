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
    case joinGroup
    case createGroup
}

struct SocialView: View {
    
    @Binding var ImageCache: [String: UIImage]
    
    @State private var selectedTab: tabPage = .Friends
    @State private var selection = tabPage.Friends
    @State var displayPopup = popupState.None
    
    var body: some View {
        NavigationView{
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
                .disabled(displayPopup != popupState.None)
                .opacity(displayPopup == .None ? 1: 0.5)
                if selection == .Friends {
                    FriendsView(ImageCache: $ImageCache, displayPopup: $displayPopup)
                } else {
                    GroupsView(ImageCache: $ImageCache, displayPopup: $displayPopup)
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
