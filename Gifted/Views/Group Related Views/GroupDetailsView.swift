//
//  GroupDetailsView.swift
//  Gifted
//
//  Created by Edwin Tang on 11/12/2022.
//

import Amplify
import SwiftUI


struct GroupDetailsView: View {
    
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
        Title = (GroupPassed.Name) + " # " + (GroupPassed.ShortID)
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
        var addedToUser = false
        
        Amplify.DataStore.query(UserProfile.self, byId: userID) { result in
            switch result {
            case .success(let user):
                if var returnedUser = user {
                    var userGroups = returnedUser.Groups
                    userGroups.append(GroupPassed.id)
                    returnedUser.Groups = userGroups
                    Amplify.DataStore.save(returnedUser) { result in
                        switch result {
                        case .success:
                            print("Added Group to User")
                            addedToUser = true
                        case .failure(let error):
                            print("Could not add Group to User - \(error)")
                        }
                    }
                    
                }
            case .failure(let error):
                print("Could not get User - \(error)")
            }
        }
        if addedToUser {
            print(GroupPassed)
            GroupPassed.Members.append(userID)
            print(userID)
            print(GroupPassed)
            Amplify.DataStore.save(GroupPassed) { result in
                switch result {
                case .success:
                    
                    print("Added user to Group")
                case .failure(let error):
                    print("Could not add User to Group - \(error)")
                }
            }
        } else {
            print("Did not remove from user")
        }
        refreshGroup()
    }
    
    
    func leaveGroup() {
        
        var removedFromGroup = false
        
        let tempGroup = GroupPassed
        var groupMembers = GroupPassed.Members
        groupMembers = groupMembers.filter { $0 != userID}
        GroupPassed.Members = groupMembers
        if groupMembers.count == 0 {
            Amplify.DataStore.delete(tempGroup) { result in
                switch result {
                case .success:
                    print("No Members so Group Deleted")
                    removedFromGroup = true
                case .failure(let error):
                    print("Could not leave group - \(error)")
                }
            }
        } else {
            Amplify.DataStore.save(GroupPassed) { result in
                switch result {
                case .success:
                    print("Group left!")
                    removedFromGroup = true
                case .failure(let error):
                    print("Could not leave group - \(error)")
                }
            }
        }
        if removedFromGroup {
            Amplify.DataStore.query(UserProfile.self, byId: userID) { result in
                switch result {
                case .success(let userQueried):
                    if var queriedUser = userQueried {
                        var groupsList = queriedUser.Groups
                        groupsList = groupsList.filter { $0 != GroupPassed.id}
                        queriedUser.Groups = groupsList
                        Amplify.DataStore.save(queriedUser) {result in
                            switch result {
                            case .success:
                                print("Removed Group from User")
                            case .failure(let error):
                                print("Could not remove group from user - \(error)")
                            }
                        }
                    }
                case .failure(let error):
                    print("Could not get user to remove group - \(error)")
                }
            }
        } else {
            print("User not removed from group")
        }
        refreshGroup()
    }
    
    func refreshGroup() {
        Amplify.DataStore.query(Group.self, byId: GroupPassed.id) { result in
            switch result {
            case .success(let update):
                if let updatedItem = update {
                    GroupPassed = updatedItem
                }
            case .failure(let error):
                print("Could not update item - \(error)")
            }
        }
    }
    
    func getMembers() {
        
        var MemberList = [UserProfile]()
        
        Amplify.DataStore.query(Group.self, byId: GroupPassed.id) {result in
            switch result {
            case .success(let group):
                if let singleGroup = group {
                    print(singleGroup.Members)
                    singleGroup.Members.forEach{friend in
                        Amplify.DataStore.query(UserProfile.self, byId: friend) { result in
                            switch result {
                            case .success(let Friend):
                                if let appendingFriend = Friend {
                                    MemberList.append(appendingFriend)
                                }
                            case .failure(let error):
                                print("Could not fetch friend - \(error)")
                            }
                        }
                    }
                    self.members = MemberList
                }
            case .failure(let error):
                print("Could not fetch User - \(error)")
            }
        }
    }
}



// Preview Simulator code, disregard

//struct GroupDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        GroupDetailsView()
//    }
//}
