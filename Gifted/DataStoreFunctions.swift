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
    
    func createUser(userID: String, username: String) {
        let user = User(
            id: userID,
            Username: username,
            Lists: [String](),
            Friends: [String](),
            Groups: [String]()
        )
        Amplify.DataStore.save(user) {
            switch $0 {
            case .success:
                print("User Record Created!")
            case .failure(let error):
                print("Error creating record - \(error.localizedDescription)")
            }
        }
    }
    
    func fetchUser(userID: String) -> User {
        var returnValue = User(Username: "NULL")
        Amplify.DataStore.query(User.self, byId: userID) {
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
    
    // List related Modifications
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
    
    func deleteList(queryID: String, list: UserList) {
        var user = fetchUser(userID: queryID)
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
}
