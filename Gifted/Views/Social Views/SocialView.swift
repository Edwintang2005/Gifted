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
    
    let tabHeight = UIScreen.main.bounds.size.height * 1/30
    @State private var selectedTab: tabPage = .Friends
    
    @State private var selection = 0
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                Text("Social")
                    .colourGradient()
                    .font(.largeTitle)
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
                    FriendsView()
                } else {
                    GroupsView()
                }
            }
        }
    }
}

struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
    }
}
