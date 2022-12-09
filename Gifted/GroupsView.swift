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
    @State var Groups = [GroupLink]()
    @State var GroupsLength = Int()
    
    var body: some View {
        ZStack {
            VStack {
                if GroupsLength == 0 {
                    Spacer()
                    Text("You have No Groups yet! 😢").large()
                    Spacer()
                    Text("Why don't we start by adding an item using the + button!").large()
                    Spacer()
                } else {
                    List {
                        ForEach(Groups) {
                            Group in NavigationLink{
                                ListView(QueryUsername: Group.GroupID )
                            } label: {
                                Text(Group.GroupID )
                            }
                        }
                        .onDelete(perform: deleteGroup)
                    }
                }
            }
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink{
                        AddToGroups()
                    } label: {
                        Image(systemName: "plus.circle.fill").floaty()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            getGroups()
            GroupsLength = Groups.count
        }
        .navigationBarTitle("Groups")
        .navigationBarItems(trailing: (
            Button(action: {
                getGroups()
                GroupsLength = Groups.count
            }) {
                Image(systemName: "arrow.clockwise")
                    .imageScale(.large)
            }
        ))
    }
    
    
    func getGroups() {
        return // code fetching group items from DB
    }
    
    func deleteGroup(indexSet: IndexSet) {
        return // Code deleting group items from list and DB
    }
    
}

//struct GroupsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupsView()
//    }
//}
