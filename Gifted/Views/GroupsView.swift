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
    @State var Groups = [Group]()
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
                                GroupDetailsView(GroupPassed: Group)
                            } label: {
                                Text(Group.Name)
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
        let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
        
        var GroupsList = [Group]()
        
        Amplify.DataStore.query(User.self, byId: userID) {result in
            switch result {
            case .success(let user):
                if let UserObject = user {
                    print(UserObject.Groups)
                    UserObject.Groups.forEach{ groupID in
                        Amplify.DataStore.query(Group.self, byId: groupID) { result in
                            switch result {
                            case .success(let individualGroup):
                                if let group = individualGroup {
                                    GroupsList.append(group)
                                }
                            case .failure(let error):
                                print("Could not fetch group - \(error)")
                            }
                        }
                    }
                    self.Groups = GroupsList
                }
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
        
        // Need to remove group from user page
        
//        Amplify.DataStore.delete(item) { result in
//            switch result {
//            case .success:
//                print("Deleted Group")
//            case .failure(let error):
//                print("Could not delete Group - \(error)")
//            }
//        }
        
        // Need to delete group object or remove user
        
        getGroups()
    }
}

//struct GroupsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupsView()
//    }
//}
