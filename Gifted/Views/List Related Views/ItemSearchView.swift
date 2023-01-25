//
//  ItemSearchView.swift
//  Gifted
//
//  Created by Edwin Tang on 23/12/2022.
//

import SwiftUI
import Amplify

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
        NavigationView{
            VStack(alignment: .leading) {
                ScrollView(showsIndicators: false) {
                    HStack{
                        Text("Discover")
                            .colourGradient()
                            .padding(.horizontal)
                        Spacer()
                    }
                    ForEach(listitemsFiltered) {
                        Item in NavigationLink{
                            if let key = Item.ImageKey {
                                ItemDetailsView(list: $lists[listNumber], listItem: Item, ImageRender: ImageCache[key], QueryID: userID)
                            } else {
                                ItemDetailsView(list: $lists[listNumber], listItem: Item, QueryID: userID)
                            }
                        } label: {
                            HorizontalDisplayCards(listItem: Item, ImageCache: $ImageCache)
                        }
                    }
                }
            }
            .onAppear{
                getListItem()
            }
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
                        Image(systemName: "plus.square")
                            .imageScale(.large)
                    }
                }
            ))
        }
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
        } else {
            let fetchedImage = dataStore.getImage(ImageKey: Key)
            if fetchedImage != UIImage() {
                DispatchQueue.main.async{
                    ImageCache[Key] = fetchedImage
                }
            }
        }
    }
}


// Preview Simulator code, ignore

//struct ItemSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemSearchView()
//    }
//}
