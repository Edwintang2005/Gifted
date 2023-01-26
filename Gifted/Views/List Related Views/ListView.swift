//
//  ListView.swift
//  Gifted
//
//  Created by Edwin Tang on 4/12/2022.
//

import Amplify
import Combine
import SwiftUI

// Main window to display every list item
struct ListView: View {
    
    @ObservedObject var dataStore = DataStore()
    @EnvironmentObject var sessionManager: SessionManager
    
    
    @State var QueryID: String
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    let nameOfUser = UserDefaults.standard.string(forKey: "NameOfUser") ?? "NullUser"
    
    @State var userProfile = UserProfile(Username: "NULL", Name: String())
    @State var lists = [UserList]()
    @State var listitems = [ListItem]()
    @State var listNumber = 0
    
    //@State var observationToken: AnyCancellable?
    
    @State var ImageCache = [String: UIImage]()
    @State var ListLength = Int()
    @State var selfQuery = Bool()
    
    
    var body: some View {
        NavigationView{
            ZStack {
                if ListLength == 0 {
                    VStack{
                        if selfQuery == true {
                            Spacer()
                            Text("You have No List Items! 😢").large()
                            Spacer()
                            Text("Why don't we start by adding an item using the + button!").large()
                            Spacer()
                        } else {
                            Spacer()
                            Text("Your friend has no list items! 😢").large()
                            Spacer()
                        }
                    }
                } else {
                    // Code that takes retrieved list and displays each item seperately
                    if selfQuery == true {
                        List {
                            ForEach(listitems) {
                                Item in NavigationLink{
                                    if let key = Item.ImageKey {
                                        ItemDetailsView(list: $lists[listNumber], listItem: Item, ImageRender: ImageCache[key], QueryID: userProfile.id)
                                    } else {
                                        ItemDetailsView(list: $lists[listNumber], listItem: Item, QueryID: userProfile.id)
                                    }
                                } label: {
                                    HStack{
                                        // Small Icon Image Rendering
                                        if let key = Item.ImageKey {
                                            if let Render = ImageCache[key] {
                                                Image(uiImage: Render).Icon()
                                            } else {
                                                Image("ImageNotFound").Icon()
                                            }
                                        } else {
                                            Image("ImageNotFound").Icon()
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text(Item.Name).listtext()
                                            Text("$ \(Item.Price ?? "NO PRICE ATTATCHED")")
                                        }
                                        .padding(.horizontal)
                                        Spacer()
                                    }
                                    .onAppear{getImage(Imagekey: Item.ImageKey)}
                                }
                            }
                            .onDelete(perform: deleteItem)
                        }
                    } else {
                        List {
                            ForEach(listitems) {
                                Item in NavigationLink{
                                    if let key = Item.ImageKey {
                                        ItemDetailsView(list: $lists[listNumber], listItem: Item, ImageRender: ImageCache[key], QueryID: userProfile.id)
                                    } else {
                                        ItemDetailsView(list: $lists[listNumber], listItem: Item, QueryID: userProfile.id)
                                    }
                                } label: {
                                    HStack{
                                        // Small Icon Image Rendering
                                        if let key = Item.ImageKey {
                                            if let Render = ImageCache[key] {
                                                Image(uiImage: Render).Icon()
                                            } else {
                                                Image("ImageNotFound").Icon()
                                            }
                                        } else {
                                            Image("ImageNotFound").Icon()
                                        }
                                        VStack(alignment: .leading) {
                                            Text(Item.Name).listtext()
                                            Text("$ \(Item.Price ?? "No PRICE ATTATCHED")")
                                        }
                                        .padding(.horizontal)
                                        Spacer()
                                    }
                                    .onAppear{
                                        getImage(Imagekey: Item.ImageKey)
                                    }
                                }
                            }
                        }
                    }
                }
                // Structure that holds + button and pushes it to bottom right corner
                if selfQuery == true {
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            NavigationLink{
                                ItemSearchView(ImageCache: $ImageCache, lists: $lists, listNumber: $listNumber)
                            } label: {
                                Image(systemName: "plus.circle.fill").floaty()
                            }
                        }
                    }
                } else {
                    Spacer()
                }
            }
            .onAppear{
                checkUserIsSelf()
                getList()
                ListLength = listitems.count
            }
            .navigationBarTitle("\(userProfile.Username)'s List")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: (
                HStack {
                    Button(action: {
                        getList()
                        ListLength = listitems.count
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .imageScale(.large)
                    }
                }
            ))
        }
    }
    
    func checkUserIsSelf() {
        if QueryID == userID {
            selfQuery = true
        } else {
            selfQuery = false
        }
    }
    
    // Function that queries database and retrieves any list items created by the user
    func getList() {
        // Getting User Data
        userProfile = dataStore.fetchUser(userID: QueryID)
        resolveNoList()
        // Getting the list of items from user data
        lists = dataStore.fetchLists(userID: QueryID)
        listitems = dataStore.fetchListItems(listid: lists[listNumber].id)
    }
    
    // Function that deletes an item when the user clicks on the delete button
    func deleteItem(indexSet: IndexSet) {

        var updatedItems = listitems
        updatedItems.remove(atOffsets: indexSet)
        guard let item = Set(updatedItems).symmetricDifference(listitems).first else {return}
        
        // Removing item from User's List
        lists = dataStore.fetchLists(userID: QueryID)
        dataStore.changeLists(action: .removeFrom, list: lists[listNumber], change: item)
        getList()
    }
    
    // Function that loads the images for the icons (Same as in ItemSearchView)
    func getImage(Imagekey: String?) {
        guard let Key = Imagekey else {return}
        if ImageCache.keys.contains(Key) {
            return
        } else {
            let fetchedImage = dataStore.getImage(ImageKey: Key)
            if fetchedImage != UIImage() {
                DispatchQueue.main.async{
                    ImageCache[Key] = fetchedImage
                }
            }
        }
    }
    
    func resolveNoList() {
        if userProfile.Lists.count == 0 {
            dataStore.createFirstList(userID: userID, name: nameOfUser)
        }
    }
    // Need to research the necessity of this function, perhaps comes in later???
    
    //    func observeListItem() {
    //        let too = ListItem.keys
    //        observationToken = Amplify.DataStore.publisher(for: ListItem.self).sink(
    //            receiveCompletion: { completion in
    //                if case .failure(let error) = completion {
    //                    print(error)
    //                }
    //            },
    //            receiveValue: { changes in
    //                // decoding recieved model
    //                guard let item = try? changes.decodeModel(as: ListItem.self) else {return}
    //
    //                switch changes.mutationType{
    //
    //                case "create":
    //                    self.listitems.append(item)
    //
    //                case "delete":
    //                    if let index = self.listitems.firstIndex(of: item) {
    //                        self.listitems.remove(at: index)
    //                    }
    //                default:
    //                    break
    //                }
    //            }
    //        )
    //    }
}



//struct ListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListView()
//    }
//}
