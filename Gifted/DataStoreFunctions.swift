//
//  DataStoreFunctions.swift
//  Gifted
//
//  Created by Edwin Tang on 31/12/2022.
//

import Amplify
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
        Amplify.DataStore.save(user) {
            switch $0 {
            case .success:
                print("User Record Created!")
                self.createFirstList(userID: userID, name: "\(nameofUser)'s List")
            case .failure(let error):
                print("Error creating record - \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUser(userID: String) -> UserProfile {
        var returnValue = UserProfile(Username: "NULL", Name: String())
        Amplify.DataStore.query(UserProfile.self, byId: userID) {
            switch $0 {
            case .success(let result):
                print("Fetched User")
                if let unwrapped = result {
                    returnValue = unwrapped
                }
            case .failure(let error):
                print("Error fetching user - \(error.localizedDescription)")
            }
        }
        return returnValue
    }
    
    func verifUser(username: String) -> UserProfile {
        var returnValue = UserProfile(Username: "NULL", Name: String())
        let UserObj = UserProfile.keys
        Amplify.DataStore.query(UserProfile.self, where: UserObj.Username == username) {
            switch $0 {
            case .success(let userList):
                if let user = userList.first {
                    returnValue = user
                }
            case .failure(let error):
                print("Could not verify user -\(error.localizedDescription)")
            }
        }
        return returnValue
    }
    
    // List related Modifications
    func allItemsQuery() -> [ListItem] {
        var returnValue = [ListItem]()
        Amplify.DataStore.query(ListItem.self) { result in
            switch result {
            case.success(let listitems):
                returnValue = listitems
            case.failure(let error):
                print(error)
            }
        }
        return returnValue
    }
    
    func fetchLists(userID: String) -> [UserList] {
        var returnValue = [UserList]()
        let user = fetchUser(userID: userID)
        user.Lists.forEach{ listid in
            Amplify.DataStore.query(UserList.self, byId: listid) {
                switch $0 {
                case .success(let result):
                    if let result = result {
                        returnValue.append(result)
                    }
                case .failure(let error):
                    print("Could not fetch List - \(error.localizedDescription)")
                }
            }
        }
        return returnValue
    }
    
    func fetchListItems(listid: String) -> [ListItem] {
        var returnValue = [ListItem]()
        Amplify.DataStore.query(UserList.self, byId: listid) {
            switch $0 {
            case .success(let list):
                if let list = list {
                    list.ListItems.forEach{ id in
                        Amplify.DataStore.query(ListItem.self, byId: id) {
                            switch $0 {
                            case .success(let result):
                                if let unwrapped = result {
                                    returnValue.append(unwrapped)
                                }
                            case .failure(let error):
                                print("Could not fetch List Item - \(error.localizedDescription)")
                            }
                        }
                    }
                }
            case .failure(let error):
                print("Could not fetch List - \(error.localizedDescription)")
            }
        }
        return returnValue
    }
    
    func changeLists(action: Action, list: UserList, change: ListItem) {
        switch action {
        case .addTo:
            var tempList = list
            tempList.ListItems.append(change.id)
            Amplify.DataStore.save(tempList) {
                switch $0{
                case .success:
                    print("Added Item to List")
                case .failure(let error):
                    print("Could not add item - \(error.localizedDescription)")
                }
            }
        case .removeFrom:
            var tempList = list
            tempList.ListItems = tempList.ListItems.filter { $0 != change.id}
            Amplify.DataStore.save(tempList) {
                switch $0 {
                case .success:
                    print("Removed Item from List")
                case .failure(let error):
                    print("Could not remove item - \(error.localizedDescription)")
                }
            }
        }
    }
    
    func deleteList(userID: String, list: UserList) {
        var user = fetchUser(userID: userID)
        var removed = false
        user.Lists = user.Lists.filter { $0 != list.id}
        Amplify.DataStore.save(user) {
            switch $0{
            case .success:
                print("Removed List from User")
                removed = true
            case .failure(let error):
                print("Could not remove List - \(error.localizedDescription)")
            }
        }
        if removed {
            Amplify.DataStore.delete(list) {
                switch $0 {
                case .success:
                    print("Deleted List")
                case .failure(let error):
                    print("Could not delete List - \(error.localizedDescription)")
                }
            }
        }
    }
    
    func createFirstList(userID: String, name: String) {
        var created = false
        let newList = UserList(
            id: userID,
            userID: userID,
            Name: name,
            ListItems: [String]())
        Amplify.DataStore.save(newList) {
            switch $0 {
            case .success:
                print("List Created")
                created = true
            case .failure(let error):
                print("Could not create List - \(error.localizedDescription)")
            }
        }
        if created {
            var user = fetchUser(userID: userID)
            user.Lists.append(newList.id)
            Amplify.DataStore.save(user) {
                switch $0 {
                case .success:
                    print("List added to profile")
                case .failure(let error):
                    print("Could not add List to user - \(error.localizedDescription)")
                }
            }
        }
    }
    
    func createList(userID: String, name: String) {
        var created = false
        let newList = UserList(
            id: UUID().uuidString,
            userID: userID,
            Name: name,
            ListItems: [String]())
        Amplify.DataStore.save(newList) {
            switch $0 {
            case .success:
                print("List Created")
                created = true
            case .failure(let error):
                print("Could not create List - \(error.localizedDescription)")
            }
        }
        if created {
            var user = fetchUser(userID: userID)
            user.Lists.append(newList.id)
            Amplify.DataStore.save(user) {
                switch $0 {
                case .success:
                    print("List added to profile")
                case .failure(let error):
                    print("Could not add List to user - \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Friend related modifications
    func fetchFriends(userID: String) -> [UserProfile] {
        var returnValue = [UserProfile]()
        let user = fetchUser(userID: userID)
        user.Friends.forEach{ friendID in
            Amplify.DataStore.query(UserProfile.self, byId: friendID) {
                switch $0 {
                case .success(let result):
                    if let result = result {
                        returnValue.append(result)
                    }
                case .failure(let error):
                    print("Could not fetch friend - \(error.localizedDescription)")
                }
            }
        }
        return returnValue
    }
    
    func changeFriends(action: Action, userID: String, change: UserProfile) {
        switch action {
        case .addTo:
            var user = fetchUser(userID: userID)
            user.Friends.append(change.id)
            Amplify.DataStore.save(user) {
                switch $0 {
                case .success:
                    print("Added Friend to Profile!")
                case .failure(let error):
                    print("Could not add friend - \(error.localizedDescription)")
                }
            }
        case .removeFrom:
            var user = fetchUser(userID: userID)
            user.Friends = user.Friends.filter{ $0 != change.id}
            Amplify.DataStore.save(user) {
                switch $0 {
                case .success:
                    print("Removed Friend from Profile!")
                case .failure(let error):
                    print("Could not remove friend - \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Group Related Modifications
    func fetchGroups(userID: String) -> [Group] {
        var returnValue = [Group]()
        let user = fetchUser(userID: userID)
        user.Groups.forEach{ groupID in
            Amplify.DataStore.query(Group.self, byId: groupID) {
                switch $0 {
                case .success(let result):
                    if let result = result {
                        returnValue.append(result)
                    }
                case .failure(let error):
                    print("Could not fetch Group - \(error.localizedDescription)")
                }
            }
        }
        return returnValue
    }
    
    func createGroup(Groupname: String, userID: String) -> Group {
        var ShortID = UUID().uuidString
        let small = ShortID.prefix(8)
        ShortID = String(small)
        let GroupNameandID = Groupname + ShortID
        let Members = [userID]
        let GroupObj = Group(id: UUID().uuidString,
                          Name: Groupname,
                          ShortID: ShortID,
                          NameAndShortID: GroupNameandID,
                          Members: Members,
                          ImageKey: UserDefaults.standard.string(forKey: "ImageKey"))
        Amplify.DataStore.save(GroupObj) {
            switch $0 {
            case .success:
                print("Created Group Successfully")
            case .failure(let error):
                print("Could not create Group - \(error.localizedDescription)")
            }
        }
        return GroupObj
    }
}
