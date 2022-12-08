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
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    Spacer()
                    Text("Aww you have no Friends, sad 😢").pretty()
                    Spacer()
                    //                    List {
                    //                        ForEach(filterItem(listed: listitems)) {
                    //                            Item in Text( Item.id )
                    //                        }
                    //                        .onDelete(perform: deleteItem)
                }
                Spacer()
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button{
                            showAddToFriends.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .floaty()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("Friends")
            .sheet(isPresented: $showAddToFriends) {
                AddToFriends()
            }
        }
    }
}






  
//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsView()
//    }
//}
