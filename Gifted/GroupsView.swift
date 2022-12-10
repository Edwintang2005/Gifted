//
//  GroupsView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import Amplify
import SwiftUI

// Page for Groups, not built yet, however physical structures are all already built
struct GroupsView: View {
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var showAddToGroups = false
    @State var Groups = [GroupLink]()
    @State var GroupsLength = Int()
    @State var showFloatingMenu1 = false
    @State var showFloatingMenu2 = false
    
    var body: some View {
        ZStack {
            VStack {
                if GroupsLength == 0 {
                    Spacer()
                    Text("You have No saved Groups yet! 😢").large()
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
                if showFloatingMenu2 == false {
                    
                } else {
                    VStack(alignment: .trailing) {
                        NavigationLink{
                            AddToGroups()
                        } label: {
                            
                            HStack{
                                Spacer()
                                Text("Join a Group")
                                    .padding(.all)
                            }
                        }
                    }
                }
                if showFloatingMenu1 == false {
                    
                } else {
                    VStack(alignment: .trailing) {
                        NavigationLink{
                            CreateNewGroup()
                        } label: {
                            HStack{
                                Spacer()
                                Text("Create a Group")
                                    .padding(.all)
                            }
                        }
                    }
                }
                HStack{
                    Spacer()
                    Button{
                        showFloatingMenu1.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                            self.showFloatingMenu2.toggle()
                        })
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
        let username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
        let GroupsLinkObj = GroupLink.keys
        Amplify.DataStore.query(GroupLink.self, where: GroupsLinkObj.OwnerUser == username) {result in
            switch result {
            case .success(let GroupsList):
                print(GroupsList)
                self.Groups = GroupsList
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteGroup(indexSet: IndexSet) {
        print("Deleted group at \(indexSet)")
        
        var updatedList = Groups
        updatedList.remove(atOffsets: indexSet)
        
        guard let item =
            Set(updatedList)
            .symmetricDifference(Groups).first else
            {return}
        
        Amplify.DataStore.delete(item) { result in
            switch result {
            case .success:
                print("Deleted Group")
            case .failure(let error):
                print("Could not delete Group - \(error)")
            }
        }
        getGroups()
    }
}

//struct GroupsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupsView()
//    }
//}
