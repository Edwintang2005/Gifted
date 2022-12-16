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
    
    @Binding var ShowMenu: Bool
    
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
                                GroupDetailsView( GroupName: Group.GroupName, Groups: getGroup(groupID: Group.GroupID, groupName: Group.GroupName))
                            } label: {
                                Text(Group.GroupName )
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
            showFloatingMenu1 = false
            showFloatingMenu2 = false
        }
        .onDisappear{
            do {
                withAnimation {
                    self.ShowMenu.toggle()
                }
            }
        }
        .navigationBarTitle("Groups")
        .navigationBarTitleDisplayMode(.inline)
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
        let username = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
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
        let groupID = item.GroupID
        let groupName = item.GroupName
        let groupList = getGroup(groupID: groupID, groupName: groupName)
        let Group = groupList.first
        if let GroupObj = Group {
            var GroupEdited = GroupObj
            let GroupMembers = GroupObj.Members
            let GroupMembersUpdated = GroupMembers.filter{ $0 != username}
            GroupEdited.Members = GroupMembersUpdated
            if GroupMembersUpdated.count == 0 {
                Amplify.DataStore.delete(GroupObj) {result in
                    switch result {
                    case .success:
                        print("No Members left so Group Deleted")
                    case .failure(let error):
                        print(error)
                    }
                }
            } else {
                Amplify.DataStore.save(GroupEdited) {result in
                    switch result {
                    case .success:
                        print("Removed Member from Group")
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        getGroups()
    }
    
    func getGroup(groupID: String, groupName: String) -> [Group] {
        let GroupObj = Group.keys
        var GroupList = [Group]()
        let GroupNameandID = groupName + groupID
        Amplify.DataStore.query(Group.self, where: GroupObj.NameAndShortID == GroupNameandID) {result in
            switch result {
            case .success(let Group):
                GroupList = Group
            case .failure(let error):
                print(error)
            }
        }
        return GroupList
    }
}

//struct GroupsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupsView()
//    }
//}
