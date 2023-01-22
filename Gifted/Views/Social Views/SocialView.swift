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
            VStack(alignment: .leading){
                    Text("  Social")
                        .colourGradient()
                        .font(.system(size: 36, weight: .bold, design: .default))
                        .padding(.horizontal)
                
                HStack{
                    Button {
                        selectedTab = .Friends
                    } label: {
                        HStack(alignment: .center) {
                            Spacer()
                            if selectedTab == .Friends {
                                Text("Friends")
                                    .subtitle()
                                    .padding(.all)
                            } else {
                                Text("Friends")
                                    .subtitle()
                                    .padding(.all)
                            }
                            Spacer()
                        }
                    }
                    
                    Button {
                        selectedTab = .Groups
                    } label: {
                        HStack(alignment: .center) {
                            Spacer()
                            if selectedTab == .Groups {
                                Text("Groups")
                                    .subtitle()
                                    .padding(.all)
                            } else {
                                Text("Groups")
                                    .subtitle()
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
