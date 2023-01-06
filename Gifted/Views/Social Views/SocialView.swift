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
    
    let tabHeight = UIScreen.main.bounds.size.height * 1/22
    @State private var selectedTab: tabPage = .Friends
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Button {
                        selectedTab = .Friends
                    } label: {
                        HStack(alignment: .center) {
                            Spacer()
                            if selectedTab == .Friends {
                                Text("Friends")
                                    .underline()
                                    .padding(.all)
                            } else {
                                Text("Friends")
                                    .padding(.all)
                            }
                            Spacer()
                        }
                    }
                    Divider()
                    Button {
                        selectedTab = .Groups
                    } label: {
                        HStack(alignment: .center) {
                            Spacer()
                            if selectedTab == .Groups {
                                Text("Groups")
                                    .underline()
                                    .padding(.all)
                            } else {
                                Text("Groups")
                                    .padding(.all)
                            }
                            Spacer()
                        }
                       
                    }
                }
                .frame(maxHeight: tabHeight)
                .foregroundColor(.primary)
                Divider()
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
