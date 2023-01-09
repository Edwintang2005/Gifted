//
//  ItemSearchView.swift
//  Gifted
//
//  Created by Edwin Tang on 23/12/2022.
//

import SwiftUI

struct ItemSearchView: View {
    
    @ObservedObject var dataStore = DataStore()
    
    @State var listitems = [ListItem]()
    @Binding var ImageCache : [String: UIImage]
    @Binding var lists: [UserList]
    @Binding var listNumber: Int
    
    
    @State private var searchedText = ""
    let QueryUsername = UserDefaults.standard.string(forKey: "Username") ?? "NullUser"
    let userID = UserDefaults.standard.string(forKey: "UserID") ?? "NullUser"
    
    var listitemsFiltered: [ListItem] {
        if searchedText.isEmpty {
            return listitems
        } else {
            return listitems.filter { $0.Name.contains(searchedText)}
        }
    }
    
    var body: some View {
        VStack {
            List{
                ForEach(listitemsFiltered) {
                    Item in NavigationLink{
                        if let key = Item.ImageKey {
                            ItemDetailsView(list: $lists[listNumber], listItem: Item, ImageRender: ImageCache[key], QueryID: userID)
                        } else {
                            ItemDetailsView(list: $lists[listNumber], listItem: Item, QueryID: userID)
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
                        }.onAppear{getImage(Imagekey: Item.ImageKey)}
                    }
                }
            }
            
        }
        .onAppear{
            getListItem()
        }
        .navigationBarTitle("Find Items to Add")
        .searchable(text: $searchedText)
        .navigationBarItems(trailing: (
            HStack{
                Button(action: {
                    getListItem()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .imageScale(.large)
                }
                NavigationLink{
                    AddToList(lists: $lists, listNumber: $listNumber)
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
            }
        ))
    }
    
    // Function that queries database and retrieves all list items
    func getListItem() {
        listitems = dataStore.allItemsQuery()
    }
    
    // Function that loads the images for the icons (Same as in ListView)
    func getImage(Imagekey: String?) {
        guard let Key = Imagekey else {return}
        if ImageCache.keys.contains(Key) {
            return
        } 
    }
}


// Preview Simulator code, ignore

//struct ItemSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemSearchView()
//    }
//}
