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
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading) {
                Text("Social")
                    .colourGradient()
                    .font(.largeTitle)
                    .padding(.horizontal)
                HStack{
                    // Selection tab
                    Button {
                        selectedTab = .Friends
                    } label: {
                        if selectedTab == .Friends {
                            HStack(alignment: .center) {
                                Spacer()
                                Text("Friends")
                                Spacer()
                            }
                            .selected()
                        } else {
                            HStack(alignment: .center) {
                                Spacer()
                                Text("Friends")
                                Spacer()
                            }
                            .unSelected()
                        }
                    }
                    Button {
                        selectedTab = .Groups
                    } label: {
                        if selectedTab == .Groups {
                            HStack(alignment: .center) {
                                Spacer()
                                Text("Groups")
                                Spacer()
                            }
                            .selected()
                        } else {
                            HStack(alignment: .center) {
                                Spacer()
                                Text("Groups")
                                Spacer()
                            }
                            .unSelected()
                        }
                    }
                }
                .frame(maxHeight: tabHeight)
                .background(Color(.sRGB, red: 237/255, green: 240/255, blue: 241/255))
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.horizontal)
                if selectedTab == .Friends {
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
