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
    
    @EnvironmentObject var sessionManager: SessionManager
    
    @State var QueryUsername: String
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    @State var listitems = [ListItem]()
    
    //@State var observationToken: AnyCancellable?
    
    @State var ImageCache = [String: UIImage]()
    @State var ListLength = Int()
    @State var selfQuery = Bool()
    
    
    var body: some View {
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
                                    ItemDetailsView(listItem: Item, ImageRender: ImageCache[key], QueryUsername: $QueryUsername)
                                } else {
                                    ItemDetailsView(listItem: Item, QueryUsername: $QueryUsername)
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
                                        Text("$ \(Item.Price ?? "No PRICE ATTATCHED")").small()
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
                                    ItemDetailsView(listItem: Item, ImageRender: ImageCache[key], QueryUsername: $QueryUsername)
                                } else {
                                    ItemDetailsView(listItem: Item, QueryUsername: $QueryUsername)
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
                                        Text("$ \(Item.Price ?? "No PRICE ATTATCHED")").small()
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
                            ItemSearchView(ImageCache: $ImageCache)
                        } label: {
                            Image(systemName: "plus.circle.fill").floaty()
                        }
                    }
                }
            } else {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear{
            checkUserIsSelf()
            getList()
            ListLength = listitems.count
        }
        .navigationBarTitle("\(QueryUsername)'s List")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: (
            Button(action: {
                getList()
                ListLength = listitems.count
            }) {
                Image(systemName: "arrow.clockwise")
                    .imageScale(.large)
            }
        ))
    }
    
    func checkUserIsSelf() {
        if QueryUsername == UserDefaults.standard.string(forKey: "Username") ?? "NullUser" {
            selfQuery = true
        } else {
            selfQuery = false
        }
    }
    
    // Function that queries database and retrieves any list items created by the user
    func getList() {
        
        var Listitems = [ListItem]()
        
        // Getting the list of items from user data
        Amplify.DataStore.query(User.self, byId: userID) { result in
            switch result {
            case.success(let user):
                if let singleUser = user {
                    print(singleUser.Items)
                    // Appending each item in list of IDs to displayable list
                    singleUser.Items.forEach{ item in
                        Amplify.DataStore.query(ListItem.self, byId: item) { result in
                            switch result {
                            case .success(let individualItem):
                                if let appendingItem = individualItem {
                                    Listitems.append(appendingItem)
                                }
                            case .failure(let error):
                                print("Could not fetch item - \(error)")
                            }
                        }
                    }
                    self.listitems = Listitems
                }
            case.failure(let error):
                print("Could not fetch list - \(error)")
            }
        }
    }
    
    // Function that deletes an item when the user clicks on the delete button
    func deleteItem(indexSet: IndexSet) {

        var updatedItems = listitems
        updatedItems.remove(atOffsets: indexSet)
        
        guard let item = Set(updatedItems).symmetricDifference(listitems).first else {return}
        
        // Removing item from User's List
        Amplify.DataStore.query(User.self, byId: userID) { result in
            switch result {
            case.success(let user):
                if var singleUser = user {
                    var list = singleUser.Items
                    list = list.filter { $0 != item.id }
                    singleUser.Items = list
                    Amplify.DataStore.save (singleUser) {result in
                        switch result {
                        case .success:
                            print("Successfully deleted Item")
                        case .failure(let error):
                            print("Could not delete item - \(error)")
                        }
                    }
                }
            case.failure(let error):
                print("Could not fetch User - \(error)")
            }
        }
        getList()
    }
    
    // Function that deletes the image from the database alongside the deletion of the item
    func deleteImage( Imagekey: String?) {
        guard let Key = Imagekey else {return}
        Amplify.Storage.remove(key: Key) {result in
            switch result {
            case .success:
                print("Deleted Image")
            case .failure(let error):
                print("could not delete Image - \(error)")
            }
        }
    }
    
    // Function that loads the images for the icons (Same as in ItemSearchView)
    func getImage(Imagekey: String?) {
        guard let Key = Imagekey else {return}
        if ImageCache.keys.contains(Key) {
            return
        } else {
            Amplify.Storage.downloadData(key: Key) { result in
                switch result {
                case .success(let ImageData):
                    print("Fetched ImageData")
                    let image = UIImage(data: ImageData)
                    DispatchQueue.main.async{
                        ImageCache[Key] = image
                    }
                    return
                case .failure(let error):
                    print("Could not get Image URL - \(error)")
                }
            }
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
