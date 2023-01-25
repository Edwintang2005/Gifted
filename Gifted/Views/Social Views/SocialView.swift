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

struct SocialView: View {
    
    @Binding var ImageCache: [String: UIImage]
    
    @State private var selectedTab: tabPage = .Friends
    @State private var selection = 0
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                Text("Social")
                    .colourGradient()
                    .padding(.horizontal)
                Picker("", selection: $selection) {
                    Text("Friends")
                        .tag(0)
                    Text("Groups")
                        .tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                if selection == 0 {
                    FriendsView(ImageCache: $ImageCache)
                } else {
                    GroupsView(ImageCache: $ImageCache)
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
