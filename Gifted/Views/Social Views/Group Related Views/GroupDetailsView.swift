//
//  GroupDetailsView.swift
//  Gifted
//
//  Created by Edwin Tang on 11/12/2022.
//


import SwiftUI


struct GroupDetailsView: View {
    
    @ObservedObject var dataStore = DataStore()
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    @State var Title = String()
    @State var userIsInGroup = Bool()
    @State var members = [UserProfile]()
    
    @State var GroupPassed : Group
    
    var body: some View {
        VStack{
            Spacer()
            if userIsInGroup {
                List{
                    Section{
                        ForEach(members) {
                            Member in NavigationLink{
                                ListView(QueryID: userID)
                            } label: {
                                Text(Member.Username)
                                    .listtext()
                            }
                        }
                    } header: {
                        Text("Members (Including yourself):")
                    }
                }
                Button {
                    leaveGroup()
                    refreshGroup()
                    userinGroup()
                } label: {
                    Text("Leave this Group")
                }
                .pretty()
            } else {
                Button {
                    joinGroup()
                    refreshGroup()
                    userinGroup()
                } label: {
                    Text("Join this Group")
                }
                .pretty()
            }
        }
        .onAppear{
            GetTitle()
            userinGroup()
            getMembers()
            print(GroupPassed)
        }
        .navigationTitle(Title)
    }
    
    func GetTitle() {
        Title = (GroupPassed.Name) + " #" + (GroupPassed.ShortID)
    }
    
    func userinGroup() {
        if GroupPassed.Members.contains(userID) {
            userIsInGroup = true
        } else {
            userIsInGroup = false
        }
    }
    
    // Adds group to user but not user to group
    
    func joinGroup() {
        refreshGroup()
        dataStore.changeGroups(action: .addTo, userID: userID, change: GroupPassed)
        refreshGroup()
    }
    
    
    func leaveGroup() {
        refreshGroup()
        dataStore.changeGroups(action: .removeFrom, userID: userID, change: GroupPassed)
        refreshGroup()
    }
    
    func refreshGroup() {
        GroupPassed = dataStore.refreshGroup(groupID: GroupPassed.id)
    }
    
    func getMembers() {
        members = dataStore.fetchGroupMembers(groupID: GroupPassed.id)
    }
}



// Preview Simulator code, disregard

//struct GroupDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupDetailsView()
//    }
//}
