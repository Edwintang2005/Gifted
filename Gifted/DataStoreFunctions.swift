//
//  DataStoreFunctions.swift
//  Gifted
//
//  Created by Edwin Tang on 31/12/2022.
//


import Foundation

// Class for modifying any Backend elements
final class DataStore: ObservableObject {
    
    enum Action {
        case addTo
        case removeFrom
    }
    
    func createUser(userID: String, username: String, nameofUser: String) {
        let user = UserProfile(
            id: userID,
            Username: username,
            Name: nameofUser,
            Lists: [String](),
            Friends: [String](),
            Groups: [String]()
        )
    }
    
    func fetchUser(userID: String) -> UserProfile {
        var returnValue = UserProfile(
            Username: "NULL",
            Name: String(),
            Lists:["00001"],
            Friends: [String](),
            Groups: [String]())
        return returnValue
    }
    
    func verifUser(username: String) -> UserProfile {
        var returnValue = UserProfile(Username: "NULL", Name: String())
        return returnValue
    }
    
    // List related Modifications
    func allItemsQuery() -> [ListItem] {
        var returnValue = [ListItem]()
        return returnValue
    }
    
    func fetchLists(userID: String) -> [UserList] {
        var returnValue = [UserList]()
        let tempList = UserList(id: UUID().uuidString, userID: String(), Name: "TempList",ListItems: [String]())
        returnValue.append(tempList)
        return returnValue
    }
    
    func refreshList(listID: String) -> UserList {
        var returnValue = UserList(userID: String(), Name: String())
        return returnValue
    }
    
    func fetchListItems(listid: String) -> [ListItem] {
        var returnValue = [ListItem]()
        return returnValue
    }
    
    func changeLists(action: Action, list: UserList, change: ListItem) {
        switch action {
        case .addTo:
            var tempList = list
            tempList.ListItems.append(change.id)
            
        case .removeFrom:
            var tempList = list
            tempList.ListItems = tempList.ListItems.filter { $0 != change.id}
        }
    }
    
    func deleteList(userID: String, list: UserList) {
        var user = fetchUser(userID: userID)
        var removed = false
        user.Lists = user.Lists.filter { $0 != list.id}
    }
    
    func createFirstList(userID: String, name: String) {
        var created = false
        let newList = UserList(
            id: userID,
            userID: userID,
            Name: name,
            ListItems: [String]())
    }
    
    func createList(userID: String, name: String) {
        var created = false
        let newList = UserList(
            id: UUID().uuidString,
            userID: userID,
            Name: name,
            ListItems: [String]())
    }
    
    func createListItem(item: ListItem, list: UserList) -> Bool {
        var returnValue = false
        return returnValue
    }
    
    // Friend related modifications
    func fetchFriends(userID: String) -> [UserProfile] {
        var returnValue = [UserProfile]()
        let user = fetchUser(userID: userID)
        user.Friends.forEach{ friendID in
        }
        return returnValue
    }
    
    func changeFriends(action: Action, userID: String, change: UserProfile) {
        switch action {
        case .addTo:
            var user = fetchUser(userID: userID)
            user.Friends.append(change.id)
        case .removeFrom:
            var user = fetchUser(userID: userID)
            user.Friends = user.Friends.filter{ $0 != change.id}
        }
    }
    
    // Group Related Modifications
    func fetchGroups(userID: String) -> [Group] {
        var returnValue = [Group]()
        let user = fetchUser(userID: userID)
        user.Groups.forEach{ groupID in
        }
        return returnValue
    }
    
    func fetchGroupMembers(groupID: String) -> [UserProfile] {
        var returnValue = [UserProfile]()
        let group = refreshGroup(groupID: groupID)
        group.Members.forEach{ memberID in

        }
        return returnValue
    }
    
    func refreshGroup(groupID: String) -> Group {
        var returnValue = Group(Name: String(), ShortID: String(), NameAndShortID: String())

        return returnValue
    }
    
    func createGroup(Groupname: String, userID: String) -> Group {
        var ShortID = UUID().uuidString
        let small = ShortID.prefix(8)
        ShortID = String(small)
        let GroupNameandID = Groupname + ShortID
        let Members = [String]()
        let GroupObj = Group(id: UUID().uuidString,
                             Name: Groupname,
                             ShortID: ShortID,
                             NameAndShortID: GroupNameandID,
                             Members: Members,
                             ImageKey: UserDefaults.standard.string(forKey: "ImageKey"))

        return GroupObj
    }
    
    func changeGroups(action: Action, userID: String, change: Group) {
        switch action {
        case .addTo:
            var user = fetchUser(userID: userID)
            var newGroup = change
            newGroup.Members.append(userID)
            user.Groups.append(change.id)
        case .removeFrom:
            var user = fetchUser(userID: userID)
            var newGroup = change
            newGroup.Members = newGroup.Members.filter{ $0 != userID}
            user.Groups = user.Groups.filter{ $0 != change.id}
        }
    }
}
