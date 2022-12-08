//
//  FriendsView.swift
//  Gifted
//
//  Created by Edwin Tang on 3/12/2022.
//

import SwiftUI

// Page for friends lists, not yet built although buttons and structures are all done, just need backend functionality
struct FriendsView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var showAddToFriends = false
    @State var Friends = [FriendObject]()
    @State var FriendsLength = Int()
    
    var body: some View {
        ZStack {
            VStack {
                if FriendsLength == 0 {
                    Spacer()
                    Text("You have No Friends yet! 😢").large()
                    Spacer()
                    Text("Why don't we start by adding an item using the + button!").large()
                    Spacer()
                } else {
                    List {
                        ForEach(Friends) {
                            Friend in NavigationLink{
                                ListView()
                            } label: {
                                Text(Friend.name)
                            }
                        }
                    }
                }
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink{
                        AddToFriends()
                    } label: {
                            Image(systemName: "plus.circle.fill").floaty()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarTitle("Friends")
        .onAppear{
            FriendsLength = Friends.count
        }
    }
}

struct FriendObject: Identifiable {
    let id = UUID()
    let name: String
}




  
//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsView()
//    }
//}
