//
//  GroupsView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import SwiftUI

// Page for Groups, not built yet, however physical structures are all already built
struct GroupsView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var showAddToGroups = false
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    Spacer()
                    Text("Aww you have no Groups, sad 😢").pretty()
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
                            showAddToGroups.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                        .floaty()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarTitle("Groups")
            .sheet(isPresented: $showAddToGroups) {
                AddToGroups()
            }
        }
    }
}

//struct GroupsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupsView()
//    }
//}
