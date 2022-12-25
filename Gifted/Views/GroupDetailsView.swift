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
    
    @State var GroupPassed : Group
    
    
    
    var body: some View {
        VStack{
            Spacer()
            if userIsInGroup {
                List{
                    Section{
                        ForEach(GroupPassed.Members, id: \.self) {
                            Member in NavigationLink{
                                ListView(QueryUsername: Member)
                            } label: {
                                Text(Member).listtext()
                            }
                        }
                    } header: {
                        Text("Members (Including yourself):")
                    }
                }
                Button {
                    leaveGroup()
                    userinGroup()
                } label: {
                    Text("Leave this Group")
                }
                .pretty()
            } else {
                Button {
                    joinGroup()
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
        Amplify.DataStore.query(User.self, byId: userID) { result in
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
                            var groupMembers = GroupPassed.Members
                            groupMembers.append(userID)
                            GroupPassed.Members = groupMembers
                            Amplify.DataStore.save(GroupPassed) { result in
                                switch result {
                                case .success:
                                    print("Added user to Group")
                                case .failure(let error):
                                    print("Could not add User to Group - \(error)")
                                }
                            }
                        case .failure(let error):
                            print("Could not add Group to User - \(error)")
                        }
                    }
                }
            case .failure(let error):
                print("Could not get User - \(error)")
            }
        }
    }
    
    
    func leaveGroup() {
        var groupMembers = GroupPassed.Members
        groupMembers = groupMembers.filter { $0 != userID}
        GroupPassed.Members = groupMembers
        if groupMembers.count == 0 {
            Amplify.DataStore.delete(GroupPassed) { result in
                switch result {
                case .success:
                    print("No Members so Group Deleted")
                    Amplify.DataStore.query(User.self, byId: userID) { result in
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
                case .failure(let error):
                    print("Could not leave group - \(error)")
                }
            }
        } else {
            Amplify.DataStore.save(GroupPassed) { result in
                switch result {
                case .success:
                    print("Group left!")
                    Amplify.DataStore.query(User.self, byId: userID) { result in
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
                case .failure(let error):
                    print("Could not leave group - \(error)")
                }
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
