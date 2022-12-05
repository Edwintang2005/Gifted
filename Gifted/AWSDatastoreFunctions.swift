//
//  AWSDatastoreFunctions.swift
//  Gifted
//
//  Created by Edwin Tang on 5/12/2022.
//

import Foundation
import Amplify

////Create ListItem
//func creatListItem() {
//    do {
//        let item = ListItem(
//            Name: "Lorem ipsum dolor sit amet",
//            Link:  /* Provide init commands */,
//            Price: 123.45F,
//            userID: "a3f4095e-39de-43d2-baf4-f8c16f0f6f4d")
//        let savedItem = try await Amplify.DataStore.save(item)
//        print("Saved item: \(savedItem)")
//    } catch let error as DataStoreError {
//        print("Error creating item: \(error)")
//    } catch {
//        print("Unexpected error: \(error)")
//    }
//}
//
//
//
////Create User
//do {
//    let item = User(
//        Name: [],
//        Email: "test12346789@testemailtestemail.com",
//        Groups: [],
//        ListItems: [])
//    let savedItem = try await Amplify.DataStore.save(item)
//    print("Saved item: \(savedItem)")
//} catch let error as DataStoreError {
//    print("Error creating item: \(error)")
//} catch {
//    print("Unexpected error: \(error)")
//}

//Create Group
//do {
//    let item = Group(
//        users: [])
//    let savedItem = try await Amplify.DataStore.save(item)
//    print("Saved item: \(savedItem)")
//} catch let error as DataStoreError {
//    print("Error creating item: \(error)")
//} catch {
//    print("Unexpected error: \(error)")
//}
//
//
////Update
//do {
//    let updatedItem = try await Amplify.DataStore.save(item)
//    print("Updated item: \(updatedItem)")
//} catch let error as DataStoreError {
//    print("Error updating item: \(error)")
//} catch {
//    print("Unexpected error: \(error)")
//}
//
////Delete
//do {
//    try await Amplify.DataStore.delete(itemToDelete)
//    print("Deleted item: \(itemToDelete.identifier)")
//} catch let error as DataStoreError {
//    print("Error deleting item: \(error)")
//} catch {
//    print("Unexpected error: \(error)")
//}
//
//// Query ListItem
//do {
//    let items = try await Amplify.DataStore.query(ListItem.self)
//    for item in items {
//        print("ListItem ID: \(item.id)")
//    }
//} catch let error as DataStoreError {
//    print("Error querying items: \(error)")
//} catch {
//    print("Unexpected error: \(error)")
//}
//
////Query User
//do {
//    let items = try await Amplify.DataStore.query(User.self)
//    for item in items {
//        print("User ID: \(item.id)")
//    }
//} catch let error as DataStoreError {
//    print("Error querying items: \(error)")
//} catch {
//    print("Unexpected error: \(error)")
//}
//
////Query Group
//do {
//    let items = try await Amplify.DataStore.query(Group.self)
//    for item in items {
//        print("Group ID: \(item.id)")
//    }
//} catch let error as DataStoreError {
//    print("Error querying items: \(error)")
//} catch {
//    print("Unexpected error: \(error)")
//}
